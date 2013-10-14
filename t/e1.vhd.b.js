if (typeof GENERIC === 'undefined') {
    eval(read("../rt/def.js"));
    eval(exports.consts);
}

if (typeof files === 'undefined') {
    files = {};
};
files['e1.vhd'] = {
    fn: "e1.vhd",
    lines: [
        [],
        [{
            id: 0,
            txt: "library "
        }, {
            id: 1,
            txt: "ieee"
        }, {
            id: 2,
            txt: ";"
        }],
        [{
            id: 3,
            txt: "use "
        }, {
            id: 4,
            txt: "ieee"
        }, {
            id: 5,
            txt: "."
        }, {
            id: 6,
            txt: "std_logic_1164"
        }, {
            id: 7,
            txt: "."
        }, {
            id: 8,
            txt: "all"
        }, {
            id: 9,
            txt: ";"
        }],
        [],
        [{
            id: 10,
            txt: "entity "
        }, {
            id: 11,
            txt: "e1 "
        }, {
            id: 12,
            txt: "is"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 13,
            txt: "generic "
        }, {
            id: 14,
            txt: "("
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 15,
            txt: "gcnt      "
        }, {
            id: 16,
            txt: ": "
        }, {
            id: 17,
            txt: "integer "
        }, {
            id: 18,
            txt: "range "
        }, {
            id: 19,
            txt: "1 "
        }, {
            id: 20,
            txt: "to "
        }, {
            id: 21,
            txt: "4  "
        }, {
            id: 22,
            txt: ":= "
        }, {
            id: 23,
            txt: "1"
        }, {
            id: 24,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 25,
            txt: "glen      "
        }, {
            id: 26,
            txt: ": "
        }, {
            id: 27,
            txt: "integer "
        }, {
            id: 28,
            txt: "range "
        }, {
            id: 29,
            txt: "0 "
        }, {
            id: 30,
            txt: "to "
        }, {
            id: 31,
            txt: "31  "
        }, {
            id: 32,
            txt: ":= "
        }, {
            id: 33,
            txt: "0"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 34,
            txt: ")"
        }, {
            id: 35,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 36,
            txt: "port "
        }, {
            id: 37,
            txt: "("
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 38,
            txt: "clk "
        }, {
            id: 39,
            txt: ": "
        }, {
            id: 40,
            txt: "in "
        }, {
            id: 41,
            txt: "std_logic"
        }, {
            id: 42,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 43,
            txt: "rst "
        }, {
            id: 44,
            txt: ": "
        }, {
            id: 45,
            txt: "in "
        }, {
            id: 46,
            txt: "std_logic"
        }, {
            id: 47,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 48,
            txt: "in0 "
        }, {
            id: 49,
            txt: ": "
        }, {
            id: 50,
            txt: "in "
        }, {
            id: 51,
            txt: "std_logic_vector"
        }, {
            id: 52,
            txt: "("
        }, {
            id: 53,
            txt: "glen "
        }, {
            id: 54,
            txt: "downto "
        }, {
            id: 55,
            txt: "0"
        }, {
            id: 56,
            txt: ") "
        }, {
            id: 57,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 58,
            txt: "out0 "
        }, {
            id: 59,
            txt: ": "
        }, {
            id: 60,
            txt: "out "
        }, {
            id: 61,
            txt: "std_logic_vector"
        }, {
            id: 62,
            txt: "("
        }, {
            id: 63,
            txt: "glen "
        }, {
            id: 64,
            txt: "downto "
        }, {
            id: 65,
            txt: "0"
        }, {
            id: 66,
            txt: ")"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 67,
            txt: ")"
        }, {
            id: 68,
            txt: ";"
        }],
        [{
            id: 69,
            txt: "end"
        }, {
            id: 70,
            txt: ";"
        }],
        [],
        [{
            id: 71,
            txt: "architecture "
        }, {
            id: 72,
            txt: "rtl "
        }, {
            id: 73,
            txt: "of "
        }, {
            id: 74,
            txt: "e1 "
        }, {
            id: 75,
            txt: "is"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 76,
            txt: "signal "
        }, {
            id: 77,
            txt: "s0"
        }, {
            id: 78,
            txt: ","
        }, {
            id: 79,
            txt: "s1 "
        }, {
            id: 80,
            txt: ": "
        }, {
            id: 81,
            txt: "std_logic"
        }, {
            id: 82,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 83,
            txt: "signal "
        }, {
            id: 84,
            txt: "sv0 "
        }, {
            id: 85,
            txt: ": "
        }, {
            id: 86,
            txt: "std_logic_vector"
        }, {
            id: 87,
            txt: "("
        }, {
            id: 88,
            txt: "1 "
        }, {
            id: 89,
            txt: "downto "
        }, {
            id: 90,
            txt: "0"
        }, {
            id: 91,
            txt: ")"
        }, {
            id: 92,
            txt: ";"
        }],
        [{
            id: 93,
            txt: "begin"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 94,
            txt: "s1 "
        }, {
            id: 95,
            txt: "<= "
        }, {
            id: 96,
            txt: "s0 "
        }, {
            id: 97,
            txt: "after "
        }, {
            id: 98,
            txt: "2 "
        }, {
            id: 99,
            txt: "ns"
        }, {
            id: 100,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 101,
            txt: "p0 "
        }, {
            id: 102,
            txt: ": "
        }, {
            id: 103,
            txt: "process"
        }, {
            id: 104,
            txt: "("
        }, {
            id: 105,
            txt: "rst"
        }, {
            id: 106,
            txt: ", "
        }, {
            id: 107,
            txt: "in0"
        }, {
            id: 108,
            txt: ")"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 109,
            txt: "variable "
        }, {
            id: 110,
            txt: "v0"
        }, {
            id: 111,
            txt: ", "
        }, {
            id: 112,
            txt: "v1 "
        }, {
            id: 113,
            txt: ": "
        }, {
            id: 114,
            txt: "std_logic "
        }, {
            id: 115,
            txt: ":= "
        }, {
            id: 116,
            txt: "'0'"
        }, {
            id: 117,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 118,
            txt: "begin"
        }],
        [{
            id: -1,
            txt: "    "
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 119,
            txt: "v1 "
        }, {
            id: 120,
            txt: ":= "
        }, {
            id: 121,
            txt: "'0'"
        }, {
            id: 122,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 123,
            txt: "v0 "
        }, {
            id: 124,
            txt: ":= "
        }, {
            id: 125,
            txt: "'0'"
        }, {
            id: 126,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 127,
            txt: "if "
        }, {
            id: 128,
            txt: "("
        }, {
            id: 129,
            txt: "not "
        }, {
            id: 130,
            txt: "("
        }, {
            id: 131,
            txt: "in0"
        }, {
            id: 132,
            txt: "("
        }, {
            id: 133,
            txt: "1 "
        }, {
            id: 134,
            txt: "downto "
        }, {
            id: 135,
            txt: "0"
        }, {
            id: 136,
            txt: ") "
        }, {
            id: 137,
            txt: "= "
        }, {
            id: 138,
            txt: "\"01\" "
        }, {
            id: 139,
            txt: "or "
        }, {
            id: 140,
            txt: "in0"
        }, {
            id: 141,
            txt: "("
        }, {
            id: 142,
            txt: "0"
        }, {
            id: 143,
            txt: ") "
        }, {
            id: 144,
            txt: "= "
        }, {
            id: 145,
            txt: "'0'"
        }, {
            id: 146,
            txt: ")"
        }, {
            id: 147,
            txt: ") "
        }, {
            id: 148,
            txt: "then"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 149,
            txt: "if "
        }, {
            id: 150,
            txt: "("
        }, {
            id: 151,
            txt: "in0"
        }, {
            id: 152,
            txt: "("
        }, {
            id: 153,
            txt: "1"
        }, {
            id: 154,
            txt: ") "
        }, {
            id: 155,
            txt: "= "
        }, {
            id: 156,
            txt: "'0'"
        }, {
            id: 157,
            txt: ") "
        }, {
            id: 158,
            txt: "then"
        }],
        [{
            id: -1,
            txt: "        "
        }, {
            id: 159,
            txt: "v0 "
        }, {
            id: 160,
            txt: ":= "
        }, {
            id: 161,
            txt: "'0'"
        }, {
            id: 162,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 163,
            txt: "end "
        }, {
            id: 164,
            txt: "if"
        }, {
            id: 165,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 166,
            txt: "v0 "
        }, {
            id: 167,
            txt: ":= "
        }, {
            id: 168,
            txt: "'1'"
        }, {
            id: 169,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 170,
            txt: "else"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 171,
            txt: "v0 "
        }, {
            id: 172,
            txt: ":= "
        }, {
            id: 173,
            txt: "'0'"
        }, {
            id: 174,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 175,
            txt: "end "
        }, {
            id: 176,
            txt: "if"
        }, {
            id: 177,
            txt: ";"
        }],
        [],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 178,
            txt: "if "
        }, {
            id: 179,
            txt: "("
        }, {
            id: 180,
            txt: "in0"
        }, {
            id: 181,
            txt: "("
        }, {
            id: 182,
            txt: "2"
        }, {
            id: 183,
            txt: ") "
        }, {
            id: 184,
            txt: "= "
        }, {
            id: 185,
            txt: "'0'"
        }, {
            id: 186,
            txt: ") "
        }, {
            id: 187,
            txt: "then"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 188,
            txt: "if "
        }, {
            id: 189,
            txt: "("
        }, {
            id: 190,
            txt: "in0"
        }, {
            id: 191,
            txt: "("
        }, {
            id: 192,
            txt: "3"
        }, {
            id: 193,
            txt: ") "
        }, {
            id: 194,
            txt: "= "
        }, {
            id: 195,
            txt: "'0'"
        }, {
            id: 196,
            txt: ") "
        }, {
            id: 197,
            txt: "then"
        }],
        [{
            id: -1,
            txt: "        "
        }, {
            id: 198,
            txt: "v1 "
        }, {
            id: 199,
            txt: ":= "
        }, {
            id: 200,
            txt: "'0'"
        }, {
            id: 201,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 202,
            txt: "end "
        }, {
            id: 203,
            txt: "if"
        }, {
            id: 204,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 205,
            txt: "v1 "
        }, {
            id: 206,
            txt: ":= "
        }, {
            id: 207,
            txt: "'1'"
        }, {
            id: 208,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 209,
            txt: "else"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 210,
            txt: "v1 "
        }, {
            id: 211,
            txt: ":= "
        }, {
            id: 212,
            txt: "'0'"
        }, {
            id: 213,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 214,
            txt: "end "
        }, {
            id: 215,
            txt: "if"
        }, {
            id: 216,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 217,
            txt: "out0"
        }, {
            id: 218,
            txt: "("
        }, {
            id: 219,
            txt: "1 "
        }, {
            id: 220,
            txt: "downto "
        }, {
            id: 221,
            txt: "0"
        }, {
            id: 222,
            txt: ") "
        }, {
            id: 223,
            txt: "<= "
        }, {
            id: 224,
            txt: "v0 "
        }, {
            id: 225,
            txt: "& "
        }, {
            id: 226,
            txt: "v1"
        }, {
            id: 227,
            txt: "; --v0 & v1;"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 228,
            txt: "out0"
        }, {
            id: 229,
            txt: "("
        }, {
            id: 230,
            txt: "1"
        }, {
            id: 231,
            txt: ") "
        }, {
            id: 232,
            txt: "<= "
        }, {
            id: 233,
            txt: "v1"
        }, {
            id: 234,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 235,
            txt: "end "
        }, {
            id: 236,
            txt: "process"
        }, {
            id: 237,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }],
        [{
            id: 238,
            txt: "end"
        }, {
            id: 239,
            txt: ";"
        }],
        [],
        [{
            id: 240,
            txt: "library "
        }, {
            id: 241,
            txt: "ieee"
        }, {
            id: 242,
            txt: ";"
        }],
        [{
            id: 243,
            txt: "use "
        }, {
            id: 244,
            txt: "ieee"
        }, {
            id: 245,
            txt: "."
        }, {
            id: 246,
            txt: "std_logic_1164"
        }, {
            id: 247,
            txt: "."
        }, {
            id: 248,
            txt: "all"
        }, {
            id: 249,
            txt: ";"
        }],
        [],
        [{
            id: 250,
            txt: "package "
        }, {
            id: 251,
            txt: "libe1 "
        }, {
            id: 252,
            txt: "is"
        }],
        [],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 253,
            txt: "component "
        }, {
            id: 254,
            txt: "e1 "
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 255,
            txt: "generic "
        }, {
            id: 256,
            txt: "("
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 257,
            txt: "gcnt      "
        }, {
            id: 258,
            txt: ": "
        }, {
            id: 259,
            txt: "integer "
        }, {
            id: 260,
            txt: "range "
        }, {
            id: 261,
            txt: "1 "
        }, {
            id: 262,
            txt: "to "
        }, {
            id: 263,
            txt: "4  "
        }, {
            id: 264,
            txt: ":= "
        }, {
            id: 265,
            txt: "1"
        }, {
            id: 266,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 267,
            txt: "glen      "
        }, {
            id: 268,
            txt: ": "
        }, {
            id: 269,
            txt: "integer "
        }, {
            id: 270,
            txt: "range "
        }, {
            id: 271,
            txt: "0 "
        }, {
            id: 272,
            txt: "to "
        }, {
            id: 273,
            txt: "31  "
        }, {
            id: 274,
            txt: ":= "
        }, {
            id: 275,
            txt: "0"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 276,
            txt: ")"
        }, {
            id: 277,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 278,
            txt: "port "
        }, {
            id: 279,
            txt: "("
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 280,
            txt: "clk "
        }, {
            id: 281,
            txt: ": "
        }, {
            id: 282,
            txt: "in "
        }, {
            id: 283,
            txt: "std_logic"
        }, {
            id: 284,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 285,
            txt: "rst "
        }, {
            id: 286,
            txt: ": "
        }, {
            id: 287,
            txt: "in "
        }, {
            id: 288,
            txt: "std_logic"
        }, {
            id: 289,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 290,
            txt: "in0 "
        }, {
            id: 291,
            txt: ": "
        }, {
            id: 292,
            txt: "in "
        }, {
            id: 293,
            txt: "std_logic_vector"
        }, {
            id: 294,
            txt: "("
        }, {
            id: 295,
            txt: "glen "
        }, {
            id: 296,
            txt: "downto "
        }, {
            id: 297,
            txt: "0"
        }, {
            id: 298,
            txt: ")"
        }, {
            id: 299,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 300,
            txt: "out0 "
        }, {
            id: 301,
            txt: ": "
        }, {
            id: 302,
            txt: "out "
        }, {
            id: 303,
            txt: "std_logic_vector"
        }, {
            id: 304,
            txt: "("
        }, {
            id: 305,
            txt: "glen "
        }, {
            id: 306,
            txt: "downto "
        }, {
            id: 307,
            txt: "0"
        }, {
            id: 308,
            txt: ")"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 309,
            txt: ")"
        }, {
            id: 310,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 311,
            txt: "end "
        }, {
            id: 312,
            txt: "component"
        }, {
            id: 313,
            txt: ";"
        }],
        [],
        [{
            id: 314,
            txt: "end"
        }, {
            id: 315,
            txt: ";"
        }]
    ]
};
if (typeof entities === 'undefined') {
    entities = {};
};
entities['e1'] = {
    type: 'ENTITY',
    name: "e1",
    generics: [{
        type: GENERIC,
        name: "gcnt",
        mode: "in ",
        typedef: {
            type: INTEGERSUBTYPE,
            range: {
                type: RANGEEXPRESSION,
                left: {
                    type: INTLITERAL,
                    value: "1",
                    loc: "19"
                },
                right: {
                    type: INTLITERAL,
                    value: "4",
                    loc: "21"
                },
                dir: "to"
            },
            loc: "17"
        },
        init: {
            type: INTLITERAL,
            value: "1",
            loc: "23"
        },
        loc: "15"
    }, {
        type: GENERIC,
        name: "glen",
        mode: "in ",
        typedef: {
            type: INTEGERSUBTYPE,
            range: {
                type: RANGEEXPRESSION,
                left: {
                    type: INTLITERAL,
                    value: "0",
                    loc: "29"
                },
                right: {
                    type: INTLITERAL,
                    value: "31",
                    loc: "31"
                },
                dir: "to"
            },
            loc: "27"
        },
        init: {
            type: INTLITERAL,
            value: "0",
            loc: "33"
        },
        loc: "25"
    }],
    ports: [{
        type: GENERIC,
        name: "gcnt",
        mode: "in ",
        typedef: {
            type: INTEGERSUBTYPE,
            range: {
                type: RANGEEXPRESSION,
                left: {
                    type: INTLITERAL,
                    value: "1",
                    loc: "19"
                },
                right: {
                    type: INTLITERAL,
                    value: "4",
                    loc: "21"
                },
                dir: "to"
            },
            loc: "17"
        },
        init: {
            type: INTLITERAL,
            value: "1",
            loc: "23"
        },
        loc: "15"
    }, {
        type: GENERIC,
        name: "glen",
        mode: "in ",
        typedef: {
            type: INTEGERSUBTYPE,
            range: {
                type: RANGEEXPRESSION,
                left: {
                    type: INTLITERAL,
                    value: "0",
                    loc: "29"
                },
                right: {
                    type: INTLITERAL,
                    value: "31",
                    loc: "31"
                },
                dir: "to"
            },
            loc: "27"
        },
        init: {
            type: INTLITERAL,
            value: "0",
            loc: "33"
        },
        loc: "25"
    }]
};
if (typeof arch === 'undefined') {
    arch = {};
};
if (typeof arch['e1'] === 'undefined') {
    arch['e1'] = {};
};
arch['e1']['rtl'] = {
    type: ARCHITECTURE,
    name: "rtl",
    of: "e1",
    decls: [{
        type: SIGNAL,
        name: "s0",
        typdef: {
            type: TYPEENUM,
            name: "std_logic"
        },
        loc: "77"
    }, {
        type: SIGNAL,
        name: "s1",
        typdef: {
            type: TYPEENUM,
            name: "std_logic"
        },
        loc: "79"
    }, {
        type: SIGNAL,
        name: "sv0",
        typdef: {
            type: TYPECONSTRAINEDARRAY,
            range: {
                type: RANGEEXPRESSION,
                left: {
                    type: INTLITERAL,
                    value: "1",
                    loc: "88"
                },
                right: {
                    type: INTLITERAL,
                    value: "0",
                    loc: "90"
                },
                dir: "downto"
            },
            typmark: "std_logic_vector",
            loc: "87"
        },
        loc: "84"
    }],
    procs: [{
        type: PROCESS,
        label: "p0",
        decls: [{
            type: VAR,
            name: "v0",
            typedef: {
                type: TYPEENUM,
                name: "std_logic"
            },
            initializer: {
                type: ENUMLITERAL,
                value: "'0'",
                loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
            },
            loc: "110"
        }, {
            type: VAR,
            name: "v1",
            typedef: {
                type: TYPEENUM,
                name: "std_logic"
            },
            initializer: {
                type: ENUMLITERAL,
                value: "'0'",
                loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
            },
            loc: "112"
        }],
        block: [{
            type: BLOCKSTATEMENT,
            body: [{
                type: ASSIGNMENTEXPRESSIONVAR,
                left: {
                    type: IDENTIFIER,
                    phase: 'name',
                    value: "v1",
                    loc: "119"
                },
                right: {
                    type: ENUMLITERAL,
                    value: "'0'",
                    loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
                },
                loc: "119"
            }, {
                type: ASSIGNMENTEXPRESSIONVAR,
                left: {
                    type: IDENTIFIER,
                    phase: 'name',
                    value: "v0",
                    loc: "123"
                },
                right: {
                    type: ENUMLITERAL,
                    value: "'0'",
                    loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
                },
                loc: "123"
            }, {
                type: IFSTATEMENT,
                test: {
                    type: UNARYEXPRESSION,
                    operator: NOT,
                    left: {
                        type: BINARYEXPRESSION,
                        operator: OR,
                        left: {
                            type: BINARYEXPRESSION,
                            operator: EQ,
                            left: {
                                type: SLICEEXPRESSION,
                                object: {
                                    type: IDENTIFIER,
                                    phase: 'sig',
                                    value: "in0",
                                    loc: "48"
                                },
                                range: {
                                    type: RANGEEXPRESSION,
                                    left: {
                                        type: INTLITERAL,
                                        value: "1",
                                        loc: "133"
                                    },
                                    right: {
                                        type: INTLITERAL,
                                        value: "0",
                                        loc: "135"
                                    },
                                    loc: "133"
                                },
                                loc: "132"
                            },
                            right: {
                                type: STRINGLITERAL,
                                value: "01",
                                loc: "138"
                            },
                            loc: "137"
                        },
                        right: {
                            type: BINARYEXPRESSION,
                            operator: EQ,
                            left: {
                                type: INDEXEXPRESSION,
                                object: {
                                    type: IDENTIFIER,
                                    phase: 'sig',
                                    value: "in0",
                                    loc: "48"
                                },
                                indexes: [{
                                    type: INTLITERAL,
                                    value: "0",
                                    loc: "142"
                                }],
                                loc: "141"
                            },
                            right: {
                                type: ENUMLITERAL,
                                value: "'0'",
                                loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
                            },
                            loc: "144"
                        },
                        loc: "139"
                    },
                    loc: "129"
                },
                consequence: {
                    type: BLOCKSTATEMENT,
                    body: [{
                        type: IFSTATEMENT,
                        test: {
                            type: BINARYEXPRESSION,
                            operator: EQ,
                            left: {
                                type: INDEXEXPRESSION,
                                object: {
                                    type: IDENTIFIER,
                                    phase: 'sig',
                                    value: "in0",
                                    loc: "48"
                                },
                                indexes: [{
                                    type: INTLITERAL,
                                    value: "1",
                                    loc: "153"
                                }],
                                loc: "152"
                            },
                            right: {
                                type: ENUMLITERAL,
                                value: "'0'",
                                loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
                            },
                            loc: "155"
                        },
                        consequence: {
                            type: BLOCKSTATEMENT,
                            body: [{
                                type: ASSIGNMENTEXPRESSIONVAR,
                                left: {
                                    type: IDENTIFIER,
                                    phase: 'name',
                                    value: "v0",
                                    loc: "159"
                                },
                                right: {
                                    type: ENUMLITERAL,
                                    value: "'0'",
                                    loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
                                },
                                loc: "159"
                            }],
                            loc: "159"
                        }
                    }, {
                        type: ASSIGNMENTEXPRESSIONVAR,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "v0",
                            loc: "166"
                        },
                        right: {
                            type: ENUMLITERAL,
                            value: "'1'",
                            loc: "../../../../libraries/ieee/std_logic_1164.v93:44:26"
                        },
                        loc: "166"
                    }],
                    loc: "149"
                },
                alternate: {
                    type: BLOCKSTATEMENT,
                    body: [{
                        type: ASSIGNMENTEXPRESSIONVAR,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "v0",
                            loc: "171"
                        },
                        right: {
                            type: ENUMLITERAL,
                            value: "'0'",
                            loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
                        },
                        loc: "171"
                    }],
                    loc: "171"
                }
            }, {
                type: IFSTATEMENT,
                test: {
                    type: BINARYEXPRESSION,
                    operator: EQ,
                    left: {
                        type: INDEXEXPRESSION,
                        object: {
                            type: IDENTIFIER,
                            phase: 'sig',
                            value: "in0",
                            loc: "48"
                        },
                        indexes: [{
                            type: INTLITERAL,
                            value: "2",
                            loc: "182"
                        }],
                        loc: "181"
                    },
                    right: {
                        type: ENUMLITERAL,
                        value: "'0'",
                        loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
                    },
                    loc: "184"
                },
                consequence: {
                    type: BLOCKSTATEMENT,
                    body: [{
                        type: IFSTATEMENT,
                        test: {
                            type: BINARYEXPRESSION,
                            operator: EQ,
                            left: {
                                type: INDEXEXPRESSION,
                                object: {
                                    type: IDENTIFIER,
                                    phase: 'sig',
                                    value: "in0",
                                    loc: "48"
                                },
                                indexes: [{
                                    type: INTLITERAL,
                                    value: "3",
                                    loc: "192"
                                }],
                                loc: "191"
                            },
                            right: {
                                type: ENUMLITERAL,
                                value: "'0'",
                                loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
                            },
                            loc: "194"
                        },
                        consequence: {
                            type: BLOCKSTATEMENT,
                            body: [{
                                type: ASSIGNMENTEXPRESSIONVAR,
                                left: {
                                    type: IDENTIFIER,
                                    phase: 'name',
                                    value: "v1",
                                    loc: "198"
                                },
                                right: {
                                    type: ENUMLITERAL,
                                    value: "'0'",
                                    loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
                                },
                                loc: "198"
                            }],
                            loc: "198"
                        }
                    }, {
                        type: ASSIGNMENTEXPRESSIONVAR,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "v1",
                            loc: "205"
                        },
                        right: {
                            type: ENUMLITERAL,
                            value: "'1'",
                            loc: "../../../../libraries/ieee/std_logic_1164.v93:44:26"
                        },
                        loc: "205"
                    }],
                    loc: "188"
                },
                alternate: {
                    type: BLOCKSTATEMENT,
                    body: [{
                        type: ASSIGNMENTEXPRESSIONVAR,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "v1",
                            loc: "210"
                        },
                        right: {
                            type: ENUMLITERAL,
                            value: "'0'",
                            loc: "../../../../libraries/ieee/std_logic_1164.v93:43:26"
                        },
                        loc: "210"
                    }],
                    loc: "210"
                }
            }, {
                type: ASSIGNMENTEXPRESSIONSIG,
                left: {
                    type: SLICEEXPRESSION,
                    object: {
                        type: IDENTIFIER,
                        phase: 'sig',
                        value: "out0",
                        loc: "58"
                    },
                    range: {
                        type: RANGEEXPRESSION,
                        left: {
                            type: INTLITERAL,
                            value: "1",
                            loc: "219"
                        },
                        right: {
                            type: INTLITERAL,
                            value: "0",
                            loc: "221"
                        },
                        loc: "219"
                    },
                    loc: "218"
                },
                right: [{
                    type: WAVEFORM,
                    elem: {
                        type: BINARYEXPRESSION,
                        operator: CONCAT,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "v0",
                            loc: "224"
                        },
                        right: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "v1",
                            loc: "226"
                        },
                        loc: "225"
                    }
                }],
                loc: "217"
            }, {
                type: ASSIGNMENTEXPRESSIONSIG,
                left: {
                    type: INDEXEXPRESSION,
                    object: {
                        type: IDENTIFIER,
                        phase: 'sig',
                        value: "out0",
                        loc: "58"
                    },
                    indexes: [{
                        type: INTLITERAL,
                        value: "1",
                        loc: "230"
                    }],
                    loc: "229"
                },
                right: [{
                    type: WAVEFORM,
                    elem: {
                        type: IDENTIFIER,
                        phase: 'name',
                        value: "v1",
                        loc: "233"
                    }
                }],
                loc: "228"
            }],
            loc: "119"
        }]
    }],
    concs: [{
        u: "undeftyp: Hdl::Stmt::ConcAssign::Sig=HASH(0x7fa2c9289148)"
    }]
}; /* Package decl libe1 */
if (typeof package === 'undefined') {
    package = {};
};
package['libe1'] = {
    type: PACKAGE,
    decls: [{
        type: COMPONENT,
        generics: [{
            type: GENERIC,
            name: "gcnt",
            mode: "in ",
            typedef: {
                type: INTEGERSUBTYPE,
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "1",
                        loc: "261"
                    },
                    right: {
                        type: INTLITERAL,
                        value: "4",
                        loc: "263"
                    },
                    dir: "to"
                },
                loc: "259"
            },
            init: {
                type: INTLITERAL,
                value: "1",
                loc: "265"
            },
            loc: "257"
        }, {
            type: GENERIC,
            name: "glen",
            mode: "in ",
            typedef: {
                type: INTEGERSUBTYPE,
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "0",
                        loc: "271"
                    },
                    right: {
                        type: INTLITERAL,
                        value: "31",
                        loc: "273"
                    },
                    dir: "to"
                },
                loc: "269"
            },
            init: {
                type: INTLITERAL,
                value: "0",
                loc: "275"
            },
            loc: "267"
        }],
        ports: [{
            type: GENERIC,
            name: "gcnt",
            mode: "in ",
            typedef: {
                type: INTEGERSUBTYPE,
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "1",
                        loc: "261"
                    },
                    right: {
                        type: INTLITERAL,
                        value: "4",
                        loc: "263"
                    },
                    dir: "to"
                },
                loc: "259"
            },
            init: {
                type: INTLITERAL,
                value: "1",
                loc: "265"
            },
            loc: "257"
        }, {
            type: GENERIC,
            name: "glen",
            mode: "in ",
            typedef: {
                type: INTEGERSUBTYPE,
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "0",
                        loc: "271"
                    },
                    right: {
                        type: INTLITERAL,
                        value: "31",
                        loc: "273"
                    },
                    dir: "to"
                },
                loc: "269"
            },
            init: {
                type: INTLITERAL,
                value: "0",
                loc: "275"
            },
            loc: "267"
        }]
    }]
};
