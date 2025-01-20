#ifndef HOD4SP_H
#define HOD4SP_H

#include "common.h"
#include "hod4.h"

// File: std.dat0
const char hod4spFileName_13[] = "std.dat0";
const size_t hod4spPatchSize_13 = 1278;
const unsigned char hod4spPatchBuffer_13[] = {
    0x16, 0x1f, 0x63, 0xbe, 0x81, 0x04, 0x01, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0xd7, 0x26, 0x00, 0x00, 0x01, 0x2b,
    0x2f, 0x2f, 0x23, 0x69, 0x66, 0x20, 0x21, 0x28, 0x20, 0x4e, 0x4e, 0x47, 0x4c, 0x44, 0x5f, 0x50, 0x52, 0x4f, 0x46,
    0x5f, 0x48, 0x41, 0x4c, 0x46, 0x5f, 0x46, 0x4c, 0x4f, 0x41, 0x54, 0x20, 0x29, 0x0d, 0x0a, 0x09, 0x23, 0x64, 0x65,
    0x66, 0x69, 0x6e, 0x65, 0x20, 0x02, 0x00, 0x27, 0x00, 0x00, 0x4b, 0x00, 0x00, 0x00, 0x01, 0x37, 0x2f, 0x2f, 0x23,
    0x65, 0x6e, 0x64, 0x69, 0x66, 0x0d, 0x0a, 0x0d, 0x0a, 0x2f, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a,
    0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2a, 0x2f, 0x0d, 0x0a, 0x2f, 0x2a, 0x20, 0x41, 0x4d,
    0x31, 0x20, 0x53, 0x70, 0x65, 0x63, 0x69, 0x61, 0x6c, 0x09, 0x09, 0x2a, 0x2f, 0x0d, 0x02, 0x80, 0x27, 0x00, 0x00,
    0x07, 0x4f, 0x00, 0x00, 0x01, 0x38, 0x76, 0x65, 0x63, 0x34, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x4d, 0x74, 0x78,
    0x49, 0x64, 0x78, 0x3b, 0x0d, 0x0a, 0x09, 0x23, 0x69, 0x66, 0x20, 0x28, 0x20, 0x4e, 0x4e, 0x47, 0x4c, 0x44, 0x5f,
    0x4f, 0x50, 0x54, 0x5f, 0x56, 0x45, 0x52, 0x54, 0x45, 0x58, 0x5f, 0x42, 0x4c, 0x45, 0x4e, 0x44, 0x20, 0x3e, 0x20,
    0x31, 0x20, 0x29, 0x0d, 0x0a, 0x02, 0xc0, 0x76, 0x00, 0x00, 0x15, 0x01, 0x00, 0x00, 0x01, 0xf6, 0x20, 0x3d, 0x20,
    0x68, 0x61, 0x6c, 0x66, 0x33, 0x28, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20, 0x30, 0x2e,
    0x30, 0x20, 0x29, 0x3b, 0x0d, 0x0a, 0x0d, 0x0a, 0x23, 0x69, 0x66, 0x20, 0x4e, 0x4e, 0x47, 0x4c, 0x44, 0x5f, 0x4f,
    0x50, 0x54, 0x5f, 0x54, 0x41, 0x4e, 0x47, 0x45, 0x4e, 0x54, 0x5f, 0x53, 0x50, 0x41, 0x43, 0x45, 0x0d, 0x0a, 0x2f,
    0x2a, 0x20, 0x95, 0xcf, 0x8a, 0xb7, 0x8d, 0xcf, 0x82, 0xdd, 0x90, 0xda, 0x90, 0xfc, 0x20, 0x2a, 0x2f, 0x0d, 0x0a,
    0x68, 0x61, 0x6c, 0x66, 0x33, 0x09, 0x6e, 0x6e, 0x67, 0x6c, 0x67, 0x54, 0x61, 0x6e, 0x67, 0x65, 0x6e, 0x74, 0x20,
    0x3d, 0x20, 0x68, 0x61, 0x6c, 0x66, 0x33, 0x28, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20,
    0x30, 0x2e, 0x30, 0x20, 0x29, 0x3b, 0x0d, 0x0a, 0x2f, 0x2a, 0x20, 0x95, 0xcf, 0x8a, 0xb7, 0x8d, 0xcf, 0x82, 0xdd,
    0x8f, 0x5d, 0x96, 0x40, 0x90, 0xfc, 0x20, 0x2a, 0x2f, 0x0d, 0x0a, 0x68, 0x61, 0x6c, 0x66, 0x33, 0x09, 0x6e, 0x6e,
    0x67, 0x6c, 0x67, 0x42, 0x69, 0x6e, 0x6f, 0x72, 0x6d, 0x61, 0x6c, 0x20, 0x3d, 0x20, 0x68, 0x61, 0x6c, 0x66, 0x33,
    0x28, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x20, 0x29, 0x3b, 0x0d,
    0x0a, 0x23, 0x65, 0x6e, 0x64, 0x69, 0x66, 0x0d, 0x0a, 0x0d, 0x0a, 0x2f, 0x2a, 0x20, 0x83, 0x4a, 0x83, 0x81, 0x83,
    0x89, 0x82, 0xa9, 0x82, 0xe7, 0x92, 0xb8, 0x93, 0x5f, 0x82, 0xd6, 0x82, 0xcc, 0x8e, 0x8b, 0x90, 0xfc, 0x95, 0xfb,
    0x8c, 0xfc, 0x20, 0x2a, 0x2f, 0x0d, 0x0a, 0x68, 0x61, 0x6c, 0x66, 0x33, 0x09, 0x6e, 0x6e, 0x02, 0x80, 0x78, 0x00,
    0x00, 0xd9, 0x0d, 0x00, 0x00, 0x01, 0x2c, 0x69, 0x6e, 0x74, 0x28, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x4d, 0x74, 0x78,
    0x49, 0x64, 0x78, 0x2e, 0x78, 0x29, 0x2c, 0x20, 0x31, 0x2e, 0x30, 0x20, 0x29, 0x3b, 0x0d, 0x0a, 0x09, 0x23, 0x65,
    0x6c, 0x69, 0x66, 0x20, 0x28, 0x20, 0x4e, 0x4e, 0x47, 0x4c, 0x44, 0x5f, 0x4f, 0x02, 0x80, 0x86, 0x00, 0x00, 0x4a,
    0x00, 0x00, 0x00, 0x03, 0x4f, 0x01, 0x00, 0x00, 0x69, 0x6e, 0x74, 0x28, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x4d, 0x74,
    0x78, 0x49, 0x64, 0x78, 0x2e, 0x78, 0x29, 0x2c, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x57, 0x65, 0x69, 0x67, 0x68,
    0x74, 0x2e, 0x78, 0x20, 0x29, 0x3b, 0x0d, 0x0a, 0x09, 0x6e, 0x6e, 0x67, 0x6c, 0x43, 0x61, 0x6c, 0x63, 0x56, 0x65,
    0x72, 0x74, 0x65, 0x78, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x28, 0x20, 0x69, 0x6e, 0x74, 0x28, 0x6e, 0x6e, 0x67,
    0x6c, 0x61, 0x4d, 0x74, 0x78, 0x49, 0x64, 0x78, 0x2e, 0x79, 0x29, 0x2c, 0x20, 0x31, 0x2e, 0x30, 0x20, 0x2d, 0x20,
    0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2e, 0x78, 0x20, 0x29, 0x3b, 0x0d, 0x0a, 0x09,
    0x23, 0x65, 0x6c, 0x69, 0x66, 0x20, 0x28, 0x20, 0x4e, 0x4e, 0x47, 0x4c, 0x44, 0x5f, 0x4f, 0x50, 0x54, 0x5f, 0x56,
    0x45, 0x52, 0x54, 0x45, 0x58, 0x5f, 0x42, 0x4c, 0x45, 0x4e, 0x44, 0x20, 0x3d, 0x3d, 0x20, 0x33, 0x20, 0x29, 0x0d,
    0x0a, 0x09, 0x6e, 0x6e, 0x67, 0x6c, 0x43, 0x61, 0x6c, 0x63, 0x56, 0x65, 0x72, 0x74, 0x65, 0x78, 0x57, 0x65, 0x69,
    0x67, 0x68, 0x74, 0x28, 0x20, 0x69, 0x6e, 0x74, 0x28, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x4d, 0x74, 0x78, 0x49, 0x64,
    0x78, 0x2e, 0x78, 0x29, 0x2c, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2e, 0x78,
    0x20, 0x29, 0x3b, 0x0d, 0x0a, 0x09, 0x6e, 0x6e, 0x67, 0x6c, 0x43, 0x61, 0x6c, 0x63, 0x56, 0x65, 0x72, 0x74, 0x65,
    0x78, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x28, 0x20, 0x69, 0x6e, 0x74, 0x28, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x4d,
    0x74, 0x78, 0x49, 0x64, 0x78, 0x2e, 0x79, 0x29, 0x2c, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x57, 0x65, 0x69, 0x67,
    0x68, 0x74, 0x2e, 0x79, 0x20, 0x29, 0x3b, 0x0d, 0x0a, 0x09, 0x6e, 0x6e, 0x67, 0x6c, 0x43, 0x61, 0x6c, 0x63, 0x56,
    0x65, 0x72, 0x74, 0x65, 0x78, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x28, 0x20, 0x69, 0x6e, 0x74, 0x28, 0x6e, 0x6e,
    0x67, 0x6c, 0x61, 0x4d, 0x74, 0x78, 0x49, 0x64, 0x78, 0x2e, 0x7a, 0x29, 0x2c, 0x20, 0x31, 0x2e, 0x30, 0x20, 0x2d,
    0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2e, 0x78, 0x20, 0x2d, 0x20, 0x6e, 0x6e,
    0x67, 0x02, 0x00, 0x88, 0x00, 0x00, 0x4e, 0x00, 0x00, 0x00, 0x03, 0x06, 0x01, 0x00, 0x00, 0x69, 0x6e, 0x74, 0x28,
    0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x4d, 0x74, 0x78, 0x49, 0x64, 0x78, 0x2e, 0x78, 0x29, 0x2c, 0x20, 0x6e, 0x6e, 0x67,
    0x6c, 0x61, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2e, 0x78, 0x20, 0x29, 0x3b, 0x0d, 0x0a, 0x09, 0x6e, 0x6e, 0x67,
    0x6c, 0x43, 0x61, 0x6c, 0x63, 0x56, 0x65, 0x72, 0x74, 0x65, 0x78, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x28, 0x20,
    0x69, 0x6e, 0x74, 0x28, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x4d, 0x74, 0x78, 0x49, 0x64, 0x78, 0x2e, 0x79, 0x29, 0x2c,
    0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2e, 0x79, 0x20, 0x29, 0x3b, 0x0d, 0x0a,
    0x09, 0x6e, 0x6e, 0x67, 0x6c, 0x43, 0x61, 0x6c, 0x63, 0x56, 0x65, 0x72, 0x74, 0x65, 0x78, 0x57, 0x65, 0x69, 0x67,
    0x68, 0x74, 0x28, 0x20, 0x69, 0x6e, 0x74, 0x28, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x4d, 0x74, 0x78, 0x49, 0x64, 0x78,
    0x2e, 0x7a, 0x29, 0x2c, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2e, 0x7a, 0x20,
    0x29, 0x3b, 0x0d, 0x0a, 0x09, 0x6e, 0x6e, 0x67, 0x6c, 0x43, 0x61, 0x6c, 0x63, 0x56, 0x65, 0x72, 0x74, 0x65, 0x78,
    0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x28, 0x20, 0x69, 0x6e, 0x74, 0x28, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x4d, 0x74,
    0x78, 0x49, 0x64, 0x78, 0x2e, 0x77, 0x29, 0x2c, 0x0d, 0x0a, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x31, 0x2e, 0x30,
    0x20, 0x2d, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2e, 0x78, 0x20, 0x2d, 0x20,
    0x6e, 0x6e, 0x67, 0x6c, 0x61, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2e, 0x79, 0x20, 0x2d, 0x20, 0x6e, 0x6e, 0x67,
    0x6c, 0x61, 0x57, 0x65, 0x69, 0x67, 0x68, 0x74, 0x2e, 0x7a, 0x20, 0x02, 0x40, 0x89, 0x00, 0x00, 0xfc, 0x4e, 0x00,
    0x00, 0x01, 0x05, 0x09, 0x23, 0x69, 0x66, 0x09, 0x02, 0x40, 0xd8, 0x00, 0x00, 0x54, 0x00, 0x00, 0x00, 0x01, 0x6e,
    0x09, 0x23, 0x65, 0x6c, 0x73, 0x65, 0x0d, 0x0a, 0x09, 0x6c, 0x69, 0x74, 0x64, 0x69, 0x72, 0x20, 0x3d, 0x20, 0x67,
    0x6c, 0x5f, 0x4c, 0x69, 0x67, 0x68, 0x74, 0x53, 0x6f, 0x75, 0x72, 0x63, 0x65, 0x5b, 0x20, 0x6c, 0x69, 0x74, 0x6e,
    0x6f, 0x20, 0x5d, 0x2e, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x69, 0x6f, 0x6e, 0x2e, 0x78, 0x79, 0x7a, 0x3b, 0x0d, 0x0a,
    0x09, 0x23, 0x65, 0x6e, 0x64, 0x69, 0x66, 0x0d, 0x0a, 0x09, 0x2f, 0x2f, 0x6c, 0x69, 0x74, 0x64, 0x69, 0x72, 0x2e,
    0x78, 0x79, 0x20, 0x3d, 0x20, 0x67, 0x6c, 0x5f, 0x4c, 0x69, 0x67, 0x68, 0x74, 0x53, 0x6f, 0x75, 0x72, 0x63, 0x65,
    0x5b, 0x20, 0x6c, 0x69, 0x74, 0x6e, 0x6f, 0x20, 0x5d, 0x2e, 0x70, 0x6f, 0x73, 0x69, 0x74, 0x02, 0x00, 0xd9, 0x00,
    0x00, 0x81, 0x2b, 0x00, 0x00};

// File: std.dat1
const char hod4spFileName_14[] = "std.dat1";
const size_t hod4spPatchSize_14 = 1149;
const unsigned char hod4spPatchBuffer_14[] = {
    0x97, 0x73, 0x28, 0xf3, 0x85, 0xfc, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x00, 0x53, 0x20, 0x00, 0x00, 0x01, 0x2f,
    0x2f, 0x2f, 0x23, 0x69, 0x66, 0x20, 0x21, 0x28, 0x20, 0x4e, 0x4e, 0x47, 0x4c, 0x44, 0x5f, 0x50, 0x52, 0x4f, 0x46,
    0x5f, 0x48, 0x41, 0x4c, 0x46, 0x5f, 0x46, 0x4c, 0x4f, 0x41, 0x54, 0x20, 0x29, 0x0d, 0x0a, 0x09, 0x23, 0x64, 0x65,
    0x66, 0x69, 0x6e, 0x65, 0x20, 0x68, 0x61, 0x6c, 0x66, 0x02, 0x80, 0x20, 0x00, 0x00, 0x47, 0x00, 0x00, 0x00, 0x01,
    0x02, 0x2f, 0x2f, 0x02, 0x80, 0x30, 0x00, 0x00, 0x50, 0x00, 0x00, 0x00, 0x01, 0x29, 0x2f, 0x2a, 0x20, 0x55, 0x73,
    0x65, 0x72, 0x20, 0x55, 0x6e, 0x69, 0x66, 0x6f, 0x72, 0x6d, 0x09, 0x2a, 0x2f, 0x0d, 0x0a, 0x23, 0x64, 0x65, 0x66,
    0x69, 0x6e, 0x65, 0x09, 0x4e, 0x4e, 0x44, 0x41, 0x5f, 0x55, 0x53, 0x45, 0x52, 0x5f, 0x55, 0x4e, 0x49, 0x02, 0x40,
    0x21, 0x00, 0x00, 0x5e, 0x1d, 0x00, 0x00, 0x01, 0x3b, 0x20, 0x3d, 0x20, 0x68, 0x61, 0x6c, 0x66, 0x33, 0x28, 0x20,
    0x30, 0x2e, 0x30, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x20, 0x29, 0x3b, 0x0d, 0x0a, 0x0d,
    0x0a, 0x2f, 0x2a, 0x20, 0x8e, 0x8b, 0x90, 0xfc, 0x95, 0xfb, 0x8c, 0xfc, 0x20, 0x2a, 0x2f, 0x0d, 0x0a, 0x76, 0x65,
    0x63, 0x33, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x67, 0x45, 0x79, 0x65, 0x02, 0xc0, 0x3e, 0x00, 0x00, 0x4d, 0x00, 0x00,
    0x00, 0x01, 0x65, 0x20, 0x3d, 0x20, 0x68, 0x61, 0x6c, 0x66, 0x33, 0x28, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20, 0x30,
    0x2e, 0x30, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x20, 0x29, 0x3b, 0x0d, 0x0a, 0x68, 0x61, 0x6c, 0x66, 0x33, 0x20, 0x6e,
    0x6e, 0x67, 0x6c, 0x67, 0x42, 0x69, 0x6e, 0x6f, 0x72, 0x6d, 0x61, 0x6c, 0x20, 0x3d, 0x20, 0x68, 0x61, 0x6c, 0x66,
    0x33, 0x28, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x2c, 0x20, 0x30, 0x2e, 0x30, 0x20, 0x29, 0x3b,
    0x0d, 0x0a, 0x23, 0x65, 0x6e, 0x64, 0x69, 0x66, 0x0d, 0x0a, 0x0d, 0x0a, 0x2f, 0x2a, 0x20, 0x83, 0x89, 0x83, 0x43,
    0x83, 0x67, 0x83, 0x41, 0x83, 0x93, 0x83, 0x72, 0x83, 0x02, 0x40, 0x3f, 0x00, 0x00, 0x52, 0x03, 0x00, 0x00, 0x03,
    0x32, 0x02, 0x00, 0x00, 0x0d, 0x0a, 0x68, 0x61, 0x6c, 0x66, 0x34, 0x20, 0x67, 0x5f, 0x6e, 0x6e, 0x67, 0x6c, 0x76,
    0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x30, 0x31, 0x20, 0x3d, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54,
    0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x30, 0x31, 0x3b, 0x0d, 0x0a, 0x68, 0x61, 0x6c, 0x66, 0x34, 0x20, 0x67,
    0x5f, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x32, 0x33, 0x20, 0x3d, 0x20,
    0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x32, 0x33, 0x3b, 0x0d, 0x0a, 0x68,
    0x61, 0x6c, 0x66, 0x34, 0x20, 0x67, 0x5f, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72,
    0x64, 0x34, 0x35, 0x20, 0x3d, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64,
    0x34, 0x35, 0x3b, 0x0d, 0x0a, 0x68, 0x61, 0x6c, 0x66, 0x34, 0x20, 0x67, 0x5f, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54,
    0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x36, 0x37, 0x20, 0x3d, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65,
    0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x36, 0x37, 0x3b, 0x0d, 0x0a, 0x0d, 0x0a, 0x23, 0x64, 0x65, 0x66, 0x69, 0x6e,
    0x65, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x30, 0x09, 0x67, 0x5f,
    0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x30, 0x31, 0x2e, 0x78, 0x79, 0x0d,
    0x0a, 0x23, 0x64, 0x65, 0x66, 0x69, 0x6e, 0x65, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f,
    0x6f, 0x72, 0x64, 0x31, 0x09, 0x67, 0x5f, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72,
    0x64, 0x30, 0x31, 0x2e, 0x7a, 0x77, 0x0d, 0x0a, 0x23, 0x64, 0x65, 0x66, 0x69, 0x6e, 0x65, 0x20, 0x6e, 0x6e, 0x67,
    0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x32, 0x09, 0x67, 0x5f, 0x6e, 0x6e, 0x67, 0x6c, 0x76,
    0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x32, 0x33, 0x2e, 0x78, 0x79, 0x0d, 0x0a, 0x23, 0x64, 0x65, 0x66,
    0x69, 0x6e, 0x65, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x33, 0x09,
    0x67, 0x5f, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x32, 0x33, 0x2e, 0x7a,
    0x77, 0x0d, 0x0a, 0x23, 0x64, 0x65, 0x66, 0x69, 0x6e, 0x65, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78,
    0x43, 0x6f, 0x6f, 0x72, 0x64, 0x34, 0x09, 0x67, 0x5f, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f,
    0x6f, 0x72, 0x64, 0x34, 0x35, 0x2e, 0x78, 0x79, 0x0d, 0x0a, 0x23, 0x64, 0x65, 0x66, 0x69, 0x6e, 0x65, 0x20, 0x6e,
    0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x35, 0x09, 0x67, 0x5f, 0x6e, 0x6e, 0x67,
    0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x34, 0x35, 0x2e, 0x7a, 0x77, 0x0d, 0x0a, 0x23, 0x64,
    0x65, 0x66, 0x69, 0x6e, 0x65, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64,
    0x36, 0x09, 0x67, 0x5f, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x36, 0x37,
    0x2e, 0x78, 0x79, 0x0d, 0x0a, 0x23, 0x64, 0x65, 0x66, 0x69, 0x6e, 0x65, 0x20, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54,
    0x65, 0x78, 0x43, 0x6f, 0x6f, 0x72, 0x64, 0x37, 0x09, 0x67, 0x5f, 0x6e, 0x6e, 0x67, 0x6c, 0x76, 0x54, 0x65, 0x78,
    0x43, 0x6f, 0x6f, 0x72, 0x64, 0x36, 0x37, 0x2e, 0x7a, 0x77, 0x0d, 0x0a, 0x23, 0x69, 0x66, 0x20, 0x28, 0x20, 0x4e,
    0x4e, 0x47, 0x4c, 0x44, 0x5f, 0x4f, 0x50, 0x54, 0x5f, 0x54, 0x45, 0x58, 0x5f, 0x53, 0x48, 0x02, 0x00, 0x44, 0x00,
    0x00, 0xc9, 0x41, 0x00, 0x00, 0x01, 0x36, 0x09, 0x2f, 0x2a, 0x20, 0x6e, 0x56, 0x69, 0x64, 0x69, 0x61, 0x20, 0x83,
    0x68, 0x83, 0x89, 0x83, 0x43, 0x83, 0x6f, 0x38, 0x31, 0x78, 0x78, 0x91, 0xce, 0x89, 0x9e, 0x09, 0x2a, 0x2f, 0x0d,
    0x0a, 0x76, 0x61, 0x72, 0x79, 0x69, 0x6e, 0x67, 0x09, 0x68, 0x61, 0x6c, 0x66, 0x34, 0x20, 0x64, 0x65, 0x74, 0x6f,
    0x75, 0x72, 0x43, 0x6f, 0x02, 0x00, 0x86, 0x00, 0x00, 0xdb, 0x08, 0x00, 0x00, 0x01, 0x28, 0x09, 0x09, 0x09, 0x23,
    0x65, 0x6e, 0x64, 0x69, 0x66, 0x0d, 0x0a, 0x09, 0x09, 0x09, 0x23, 0x69, 0x66, 0x20, 0x28, 0x20, 0x4e, 0x4e, 0x47,
    0x4c, 0x44, 0x5f, 0x4f, 0x50, 0x54, 0x5f, 0x54, 0x45, 0x58, 0x5f, 0x55, 0x53, 0x45, 0x52, 0x32, 0x20, 0x02, 0x00,
    0x8f, 0x00, 0x00, 0x58, 0x02, 0x00, 0x00, 0x01, 0x2e, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x23, 0x65, 0x6e, 0x64,
    0x69, 0x66, 0x0d, 0x0a, 0x09, 0x09, 0x09, 0x23, 0x69, 0x66, 0x20, 0x28, 0x20, 0x4e, 0x4e, 0x47, 0x4c, 0x44, 0x5f,
    0x4f, 0x50, 0x54, 0x5f, 0x54, 0x45, 0x58, 0x5f, 0x55, 0x53, 0x45, 0x52, 0x38, 0x20, 0x21, 0x3d, 0x20, 0x02, 0x80,
    0x91, 0x00, 0x00, 0x84, 0x40, 0x00, 0x00, 0x02, 0x00, 0xd2, 0x00, 0x00, 0xb9, 0x02, 0x00, 0x00, 0x01, 0x0c, 0x09,
    0x09, 0x09, 0x09, 0x09, 0x23, 0x69, 0x66, 0x09, 0x4e, 0x4e, 0x47, 0x02, 0xc0, 0xd4, 0x00, 0x00, 0xdf, 0x04, 0x00,
    0x00, 0x01, 0x23, 0x0d, 0x0a, 0x23, 0x65, 0x6c, 0x73, 0x65, 0x0d, 0x0a, 0x09, 0x66, 0x6f, 0x72, 0x20, 0x28, 0x20,
    0x69, 0x6e, 0x74, 0x20, 0x6c, 0x69, 0x74, 0x6e, 0x6f, 0x20, 0x3d, 0x20, 0x4e, 0x4e, 0x47, 0x4c, 0x44, 0x5f, 0x4f,
    0x02, 0xc0, 0xd9, 0x00, 0x00, 0xc5, 0x22, 0x00, 0x00};

ShaderFilesToPatch hod4spShaderPatches[] = {
    {hod4FileName_0, hod4PatchSize_0, hod4PatchBuffer_0, 0, ""},
    {hod4FileName_1, hod4PatchSize_1, hod4PatchBuffer_1, 0, ""},
    {hod4FileName_2, hod4PatchSize_2, hod4PatchBuffer_2, 0, ""},
    {hod4FileName_3, hod4PatchSize_3, hod4PatchBuffer_3, 0, ""},
    {hod4FileName_4, hod4PatchSize_4, hod4PatchBuffer_4, 0, ""},
    {hod4FileName_5, hod4PatchSize_5, hod4PatchBuffer_5, 0, ""},
    {hod4FileName_6, hod4PatchSize_6, hod4PatchBuffer_6, 0, ""},
    {hod4FileName_7, hod4PatchSize_7, hod4PatchBuffer_7, 0, ""},
    {hod4FileName_8, hod4PatchSize_8, hod4PatchBuffer_8, 0, ""},
    {hod4FileName_9, hod4PatchSize_9, hod4PatchBuffer_9, 0, ""},
    {hod4FileName_10, hod4PatchSize_10, hod4PatchBuffer_10, 0, ""},
    {hod4FileName_11, hod4PatchSize_11, hod4PatchBuffer_11, 0, ""},
    {hod4FileName_12, hod4PatchSize_12, hod4PatchBuffer_12, 0, ""},
    {hod4spFileName_13, hod4spPatchSize_13, hod4spPatchBuffer_13, 0, ""},
    {hod4spFileName_14, hod4spPatchSize_14, hod4spPatchBuffer_14, 0, ""},
    {hod4FileName_15, hod4PatchSize_15, hod4PatchBuffer_15, 0, ""},
};

int hod4spShaderPatchesCount = sizeof(hod4spShaderPatches) / sizeof(ShaderFilesToPatch);

#endif