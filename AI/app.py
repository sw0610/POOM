# -*- coding: utf-8 -*-
"""
Created on Wed May 10 09:09:55 2023

@author: SSAFY
"""

from diffusers import StableDiffusionControlNetPipeline, ControlNetModel, UniPCMultistepScheduler
from diffusers.utils.testing_utils import load_image
import cv2
from PIL import Image
import numpy as np
import torch
from fastapi import FastAPI, Response, File, UploadFile
from fastapi.exceptions import HTTPException  # fastapi.exceptions 모듈 추가
from keras.models import load_model
import dlib
import io

def init():
    global pipe
    controlnet_model = "lllyasviel/sd-controlnet-canny"
    sd_model = "Lykon/DreamShaper"
     
    controlnet = ControlNetModel.from_pretrained(
        controlnet_model,
        torch_dtype=torch.float16,
    )
    
    pipe = StableDiffusionControlNetPipeline.from_pretrained(
        sd_model,
        controlnet=controlnet,
        torch_dtype=torch.float16,
    )
    pipe.scheduler = UniPCMultistepScheduler.from_config(pipe.scheduler.config)
    pipe.enable_model_cpu_offload()
    
def img2img(img_path, prompt, negative_prompt, num_steps=20, guidance_scale=7, seed=0, low=100, high=200):
    image = load_image(img_path) 
    image.thumbnail((512, 512))
    np_image = np.array(image)

    canny_image = cv2.Canny(np_image, low, high)

    canny_image = canny_image[:, :, None]
    canny_image = np.concatenate([canny_image, canny_image, canny_image], axis=2)
    canny_image = Image.fromarray(canny_image)
    
    canny_image.save('imgae.jpg',"JPEG")
    
    print("파이프 작동 전")
    
    out_image = pipe(
        prompt,
        negative_prompt=negative_prompt,
        num_inference_steps=num_steps,
        guidance_scale=guidance_scale,
        generator=torch.manual_seed(seed),
        image=canny_image
    ).images[0]
    
    print("파이프 작동 끝")

    return out_image

init()
model = load_model('./animal_face.h5', compile=False)
app = FastAPI()

def make_cartoon_img(image):    
    prompt = "(8k, best quality, masterpiece:1.2),(best quality:1.0), (ultra highres:1.0), a dog, a head ribon ,watercolor, by agnes cecile, portrait, extremely luminous bright design, pastel colors, (ink:1.3), autumn lights"
    negative_prompt = "canvas frame, cartoon, 3d, ((disfigured)), ((bad art)), ((deformed)),((extra limbs)),((close up)),((b&w)), wierd colors, blurry, (((duplicate))), ((morbid)), ((mutilated)), [out of frame], extra fingers, mutated hands, ((poorly drawn hands)), ((poorly drawn face)), (((mutation))), (((deformed))), ((ugly)), blurry, ((bad anatomy)), (((bad proportions))), ((extra limbs)), cloned face, (((disfigured))), out of frame, ugly, extra limbs, (bad anatomy), gross proportions, (malformed limbs), ((missing arms)), ((missing legs)), (((extra arms))), (((extra legs))), mutated hands, (fused fingers), (too many fingers), (((long neck))), Photoshop, video game, ugly, tiling, poorly drawn hands, poorly drawn feet, poorly drawn face, out of frame, mutation, mutated, extra limbs, extra legs, extra arms, disfigured, deformed, cross-eye, body out of frame, blurry, bad art, bad anatomy, 3d render"
    num_steps = 20
    guidance_scale = 7
    seed = 3467120481370323442
    
    out_image = img2img(image, prompt, negative_prompt, num_steps, guidance_scale, seed)

    buffer = io.BytesIO()
    out_image.save(buffer, 'JPEG')
    buffer.seek(0)
    
    return buffer

@app.post("/api2/nfts")
async def detect_dog_face(image: UploadFile = File(...)):
    # Convert UploadFile object to bytes
    image_bytes = await image.read()
    
    detector = dlib.cnn_face_detection_model_v1('./dogHeadDetector.dat')

    # Load image from memory
    image = Image.open(io.BytesIO(image_bytes))
    
    # Check the format of the image file
    if image.format not in ['JPEG', 'JPG', 'PNG']:
        return {"error": "Invalid image format. Only PNG and JPEG formats are supported."}
    elif image.format not in ['JPEG', 'JPG']:
        # Convert image to JPEG format
        buffer = io.BytesIO()
        image = image.convert('RGB')
        image.save(buffer, "JPEG")
        buffer.seek(0)
        image = Image.open(buffer)
    else:
        buffer = io.BytesIO()
        image.save(buffer, "JPEG")
        buffer.seek(0)
        image = Image.open(buffer)
    
    image.thumbnail((512, 512))

    # Convert image to an OpenCV BGR image
    opencv_image = cv2.cvtColor(np.array(image), cv2.COLOR_RGB2BGR)

    # Step 1. Using the detector model, detect dog faces in the OpenCV BGR image
    dets = detector(opencv_image, upsample_num_times=0)

    # Step 2. Draw a rectangle around each detected face
    img_result = opencv_image.copy()
    x1, y1, x2, y2 = None, None, None, None

    for i, d in enumerate(dets):
        print("Detection {}: Left : {} Top : {} Right : {} Bottom : {} Confidence : {}"
              .format(i, d.rect.left(), d.rect.top(), d.rect.right(), d.rect.bottom(), d.confidence))
        x1, y1 = d.rect.left(), d.rect.top()
        x2, y2 = d.rect.right(), d.rect.bottom()

        # Draw rectangle around the face region
        cv2.rectangle(img_result, pt1=(x1, y1), pt2=(x2, y2), thickness=2, color=(255, 0, 0), lineType=cv2.LINE_AA)

    # If the face region could not be determined, return a 404 error response
    if x1 == None or y1 == None or x2 == None or y2 == None:
        raise HTTPException(status_code=404, detail="Dog face not found")

    # Step 3. Crop the image to the detected face region
    rect_image = img_result[y1:y2, x1:x2]

    # Step 4. Resize the cropped face region to (100,100) for classification
    new_width, new_height = 100, 100
    img = cv2.resize(rect_image, (new_width, new_height))
    img = np.array(img) / 255.0
    img = np.expand_dims(img, axis=0)

    # Step 5. Use the model to predict whether the image contains a dog
    prediction = model.predict(img)
    print(prediction)
    predicted_class = np.argmax(prediction)

    # Step 6. If the image contains a dog, return the image as a response
    if predicted_class == 1:
        
        buffer = make_cartoon_img(image)
        
        buffer.seek(0)
        
        return Response(content=buffer.getvalue(), media_type="image/jpeg")

    # If the image doesn't contain a dog, return a 404 error response
    raise HTTPException(status_code=404, detail="Dog not detected")

    