#ifndef OR2_H
#define OR2_H

#include "common.h"

SearchReplace orFsMesa[] = {
    {"OPTION NV_fragment_program2;", "#OPTION NV_fragment_program2;"},
    {"ADDR\t", "ADD\t"},
    {"MULR\t", "MUL\t"},
    {"MULR  ", "MUL   "},
    {"MOVR\t", "MOV\t"},
    {"MOVR_SAT\t", "MOV_SAT\t"},
    {"MADR\t", "MAD\t"},
    {"!!FP2.0\r\n", "!!ARBfp1.0\r\n#OPTION NV_fragment_program2;\r\n"},
    {"DECLARE c0 =", "TEMP R1;\r\nTEMP R2;\r\nTEMP R3;\r\nTEMP R4;\r\nTEMP R5;\r\nPARAM c0 ="},
    {"DECLARE c", "PARAM c"},
    {"f[TEX2], TEX2, 2D;", "fragment.texcoord[2], texture[2], 2D;"},
    {"f[TEX3], TEX3, 2D;", "fragment.texcoord[3], texture[3], 2D;"},
    {"o[COLR]", "result.color"},
    {"#mul\tr0, t0, v0\r\nTEX", "#mul\tr0, t0, v0\r\nTEMP R0;\r\nTEX"},
    {"#mul\tr0, t1, r0\r\nTEX", "#mul\tr0, t1, r0\r\nTEMP R0;\r\nTEMP R1;\r\nTEX"},
    {"#mul\tr0, t2, r0\r\nTEX", "#mul\tr0, t2, r0\r\nTEMP R0;\r\nTEMP R1;\r\nTEMP R2;\r\nTEX"},
    {"#mul\tr0, t3, r0\r\nTEX", "#mul\tr0, t3, r0\r\nTEMP R0;\r\nTEMP R1;\r\nTEMP R2;\r\nTEMP R3;\r\nTEX"},
    {"f[COL0]", "fragment.color.primary"},
    {"f[TEX0]", "fragment.texcoord[0]"},
    {"f[TEX1]", "fragment.texcoord[1]"},
    {"f[TEX2]", "fragment.texcoord[2]"},
    {"f[TEX3]", "fragment.texcoord[3]"},
    {"TEX0", "texture[0]"},
    {"TEX1", "texture[1]"},
    {"TEX2", "texture[2]"},
    {"TEX3", "texture[3]"}};

int orFsMesaCount = sizeof(orFsMesa) / sizeof(SearchReplace);

SearchReplace orVsMesa[] = {
    {"!!VP2.0\nBB1:\n", "!!ARBvp1.0\n#OPTION NV_vertex_program3;\nPARAM c[215] = { program.env[0..214] };\nTEMP R0, "
                        "R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14;\n\n"},
    {"v[OPOS]", "vertex.attrib[0]"},
    {"v[NRML]", "vertex.attrib[2]"},
    {"o[HPOS]", "result.position"},
    {"o[COL0]", "result.color.primary"},
    {"o[COL1]", "result.color.secondary"},
    {"o[BFC0]", "result.color.back.primary"},
    {"o[BFC1]", "result.color.back.secondary"},
    {"o[TEX0]", "result.texcoord[0]"},
    {"o[TEX1]", "result.texcoord[1]"},
    {"o[TEX2]", "result.texcoord[2]"},
    {"o[TEX3]", "result.texcoord[3]"},
    {"o[FOGC]", "result.fogcoord"},
    {"v[TEX0]", "vertex.attrib[8]"},
    {"v[TEX1]", "vertex.attrib[9]"},
    {"v[TEX2]", "vertex.attrib[10]"},
    {"v[TEX3]", "vertex.attrib[11]"},
    {"v[COL0]", "vertex.attrib[3]"},
    {"v[WGHT]", "vertex.attrib[1]"},
    {"v[5]", "vertex.attrib[5]"},
    {"v[6]", "vertex.attrib[6]"},
    {"v[7]", "vertex.attrib[7]"},
    {"v[12]", "vertex.attrib[12]"},
    {"v[13]", "vertex.attrib[13]"},
    {"v[14]", "vertex.attrib[14]"},
    {"v[15]", "vertex.attrib[15]"},
    {"v0", "vertex.attrib[0]"},
    {"v7", "vertex.attrib[7]"},
    {"v9", "vertex.attrib[9]"},
    {"v10", "vertex.attrib[10]"}};

int orVsMesaCount = sizeof(orVsMesa) / sizeof(SearchReplace);

SearchReplace orFsNvidia[] = {
    {"!!FP2.0\r\n", "!!ARBfp1.0\r\nOPTION NV_fragment_program2;\r\n"},
    {"DECLARE c0 =", "TEMP R1;\r\nTEMP R2;\r\nTEMP R3;\r\nTEMP R4;\r\nTEMP R5;\r\nPARAM c0 ="},
    {"DECLARE c", "PARAM c"},
    {"o[COLR]", "result.color"},
    {"#mul\tr0, t0, v0\r\nTEX", "#mul\tr0, t0, v0\r\nTEMP R0;\r\nTEX"},
    {"#mul\tr0, t1, r0\r\nTEX", "#mul\tr0, t1, r0\r\nTEMP R0;\r\nTEMP R1;\r\nTEX"},
    {"#mul\tr0, t2, r0\r\nTEX", "#mul\tr0, t2, r0\r\nTEMP R0;\r\nTEMP R1;\r\nTEMP R2;\r\nTEX"},
    {"#mul\tr0, t3, r0\r\nTEX", "#mul\tr0, t3, r0\r\nTEMP R0;\r\nTEMP R1;\r\nTEMP R2;\r\nTEMP R3;\r\nTEX"},
    {"f[COL0]", "fragment.color.primary"},
    {"f[TEX0]", "fragment.texcoord[0]"},
    {"f[TEX1]", "fragment.texcoord[1]"},
    {"f[TEX2]", "fragment.texcoord[2]"},
    {"f[TEX3]", "fragment.texcoord[3]"},
    {"TEX0", "texture[0]"},
    {"TEX1", "texture[1]"},
    {"TEX2", "texture[2]"},
    {"TEX3", "texture[3]"}};

int orFsNvidiaCount = sizeof(orFsNvidia) / sizeof(SearchReplace);

SearchReplace orVsAti[] = {{"!!VP2.0\nBB1:\n",
                            "!!ARBvp1.0\nOPTION NV_vertex_program3;\nPARAM c[215] = { program.env[0..214] };\nTEMP R0, "
                            "R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14;\n\n"},
                           {"v[OPOS]", "vertex.position"},
                           {"v[NRML]", "vertex.normal"},
                           {"o[HPOS]", "result.position"},
                           {"o[COL0]", "result.color.primary"},
                           {"o[COL1]", "result.color.secondary"},
                           {"o[BFC0]", "result.color.back.primary"},
                           {"o[BFC1]", "result.color.back.secondary"},
                           {"o[TEX0]", "result.texcoord[0]"},
                           {"o[TEX1]", "result.texcoord[1]"},
                           {"o[TEX2]", "result.texcoord[2]"},
                           {"o[TEX3]", "result.texcoord[3]"},
                           {"o[FOGC]", "result.fogcoord"},
                           {"v[TEX0]", "vertex.texcoord[0]"},
                           {"v[TEX1]", "vertex.texcoord[1]"},
                           {"v[TEX2]", "vertex.texcoord[2]"},
                           {"v[TEX3]", "vertex.texcoord[3]"},
                           {"v[COL0]", "vertex.attrib[3]"},
                           {"v[WGHT]", "vertex.attrib[1]"},
                           {"v[5]", "vertex.attrib[5]"},
                           {"v[6]", "vertex.attrib[6]"},
                           {"v[7]", "vertex.attrib[7]"},
                           {"v[12]", "vertex.attrib[12]"},
                           {"v[13]", "vertex.attrib[13]"},
                           {"v[14]", "vertex.attrib[14]"},
                           {"v[15]", "vertex.attrib[15]"},
                           {"v0", "vertex.attrib[0]"},
                           {"v7", "vertex.attrib[7]"},
                           {"v9", "vertex.attrib[9]"},
                           {"v10", "vertex.attrib[10]"}};

int orVsAtiCount = sizeof(orVsAti) / sizeof(SearchReplace);

#endif