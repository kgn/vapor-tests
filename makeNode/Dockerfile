FROM vapor/vapor:1.0.5-xenial

WORKDIR /vapor
COPY Package.swift /vapor/Package.swift
COPY main.swift /vapor/main.swift

RUN vapor build

RUN vapor run
