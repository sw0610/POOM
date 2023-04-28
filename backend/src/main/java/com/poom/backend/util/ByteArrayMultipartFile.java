package com.poom.backend.util;

import io.ipfs.multihash.Multihash;
import org.springframework.http.MediaType;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;

public class ByteArrayMultipartFile implements MultipartFile {
    private final byte[] content;
    private final String name;
    private final String originalFilename;
    private final MediaType mediaType;
    private final long size;

    public ByteArrayMultipartFile(byte[] content, Multihash name) {
        this.content = content;
        this.name = String.valueOf(name);
        this.originalFilename = String.valueOf(name);
        this.mediaType = MediaType.APPLICATION_OCTET_STREAM;
        this.size = content.length;
    }

    @Override
    public String getName() {
        return this.name;
    }

    @Override
    public String getOriginalFilename() {
        return this.originalFilename;
    }

    @Override
    public String getContentType() {
        return this.mediaType.toString();
    }

    @Override
    public boolean isEmpty() {
        return this.content == null || this.content.length == 0;
    }

    @Override
    public long getSize() {
        return this.size;
    }

    @Override
    public byte[] getBytes() throws IOException {
        return this.content;
    }

    @Override
    public InputStream getInputStream() throws IOException {
        return new ByteArrayInputStream(this.content);
    }

    @Override
    public void transferTo(File file) throws IOException, IllegalStateException {
        Files.write(file.toPath(), this.content);
    }
}
