#ifndef ABC_H
#define ABC_H
#include "common.h"

// Fragment ABC
SearchReplace abcFsMesa[] = {{"\nOPTION NV_fragment_program2;", "\n"},
                             {"OPTION NV_fragment_program2;\n", "\n"},
                             {"OPTION NV_fragment_program2;", "\n"},
                             {"SHORT TEMP", "TEMP"},
                             {"SHORT OUTPUT", "OUTPUT"},
                             {"LONG TEMP", "TEMP"},
                             {"MOVH\t", "MOV\t"},
                             {"SUBH\t", "SUB\t"},
                             {"MADH\t", "MAD\t"},
                             {"RSQH\t", "RSQ\t"},
                             {"MULH\t", "MUL\t"},
                             {"DP3H\t", "DP3\t"},
                             {"LPRH\t", "LPR\t"},
                             {"LRPH\t", "LRP\t"},
                             {"r0(LT.a),", "r0,"},
                             {"SUBC\t", "SUB\t"}};

int abcFsMesaCount = sizeof(abcFsMesa) / sizeof(SearchReplace);

// Vertex ABC
SearchReplace abcVsMesa[] = {{"OPTION NV_vertex_program3;", "#OPTION NV_vertex_program3;"},
                             {"ARL _adr, vertex.attrib[7];", "ARL _adr.x, vertex.attrib[7].x;"},
                             {"|_tmp0.x|;", "_tmp0.x;"},
                             {"ARL _adr, fresnel_index;", "ARL _adr.x, fresnel_index.x;"},
                             {"|tmp.w|;", "tmp.w;"},
                             {"MOVC", "MOV"},
                             {"MADC", "MAD"},
                             {"point_lit0_skip:", ""},
                             {"point_lit1_skip:", ""},
                             {"SUBC", "SUB"},
                             {"ARL _adr, a_mtxidx;", "ARL _adr.x, a_mtxidx.x;"},
                             {"BRA skinning_pn_end (EQ.y);", "ARL _adr.x, vertex.attrib[7].y;"},
                             {"BRA skinning_pn_end (EQ.z);", "ARL _adr.x, vertex.attrib[7].z;"},
                             {"BRA skinning_pn_end (EQ.w);", "ARL _adr.x, vertex.attrib[7].w;"},
                             {"BRA skinning_end (EQ.y);", "ARL _adr.x, a_mtxidx.y;"},
                             {"BRA skinning_end (EQ.z);", "ARL _adr.x, a_mtxidx.z;"},
                             {"BRA skinning_end (EQ.w);", "ARL _adr.x, a_mtxidx.w;"},
                             {"BRA ", "#BRA "},
                             {"DP4 _tmp0.x, mtxpal[_adr.y+0]", "  DP4 _tmp0.x, mtxpal[_adr.x+0]"},
                             {"DP4 _tmp0.y, mtxpal[_adr.y+1]", "  DP4 _tmp0.y, mtxpal[_adr.x+1]"},
                             {"DP4 _tmp0.z, mtxpal[_adr.y+2]", "  DP4 _tmp0.z, mtxpal[_adr.x+2]"},
                             {"DP4 _tmp0.x, mtxpal[_adr.z+0]", "  DP4 _tmp0.x, mtxpal[_adr.x+0]"},
                             {"DP4 _tmp0.y, mtxpal[_adr.z+1]", "  DP4 _tmp0.y, mtxpal[_adr.x+1]"},
                             {"DP4 _tmp0.z, mtxpal[_adr.z+2]", "  DP4 _tmp0.z, mtxpal[_adr.x+2]"},
                             {"DP4 _tmp0.x, mtxpal[_adr.w+0]", "  DP4 _tmp0.x, mtxpal[_adr.x+0]"},
                             {"DP4 _tmp0.y, mtxpal[_adr.w+1]", "  DP4 _tmp0.y, mtxpal[_adr.x+1]"},
                             {"DP4 _tmp0.z, mtxpal[_adr.w+2]", "  DP4 _tmp0.z, mtxpal[_adr.x+2]"},
                             {"DP3 _tmp0.x, mtxpal[_adr.y+0]", "  DP3 _tmp0.x, mtxpal[_adr.x+0]"},
                             {"DP3 _tmp0.y, mtxpal[_adr.y+1]", "  DP3 _tmp0.y, mtxpal[_adr.x+1]"},
                             {"DP3 _tmp0.z, mtxpal[_adr.y+2]", "  DP3 _tmp0.z, mtxpal[_adr.x+2]"},
                             {"DP3 _tmp0.x, mtxpal[_adr.z+0]", "  DP3 _tmp0.x, mtxpal[_adr.x+0]"},
                             {"DP3 _tmp0.y, mtxpal[_adr.z+1]", "  DP3 _tmp0.y, mtxpal[_adr.x+1]"},
                             {"DP3 _tmp0.z, mtxpal[_adr.z+2]", "  DP3 _tmp0.z, mtxpal[_adr.x+2]"},
                             {"DP3 _tmp0.x, mtxpal[_adr.w+0]", "  DP3 _tmp0.x, mtxpal[_adr.x+0]"},
                             {"DP3 _tmp0.y, mtxpal[_adr.w+1]", "  DP3 _tmp0.y, mtxpal[_adr.x+1]"},
                             {"DP3 _tmp0.z, mtxpal[_adr.w+2]", "  DP3 _tmp0.z, mtxpal[_adr.x+2]"},
                             {"skinning_pn_end:", " "},
                             {"skinning_end:", " "}};

int abcVsMesaCount = sizeof(abcVsMesa) / sizeof(SearchReplace);

#endif