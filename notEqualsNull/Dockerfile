FROM vapor/vapor:1.0.5-xenial

WORKDIR /vapor
COPY Package.swift /vapor/Package.swift
COPY Sources /vapor/Sources
COPY Tests /vapor/Tests

RUN swift test
