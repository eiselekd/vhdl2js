if (typeof GENERIC === 'undefined') {
    eval(read("../rt/def.js"));
    eval(exports.consts);
}

if (typeof files === 'undefined') {
    files = {};
};
files['top.vhd'] = {
    fn: "top.vhd",
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
        [{
            id: 10,
            txt: "use "
        }, {
            id: 11,
            txt: "work"
        }, {
            id: 12,
            txt: "."
        }, {
            id: 13,
            txt: "libe1"
        }, {
            id: 14,
            txt: "."
        }, {
            id: 15,
            txt: "all"
        }, {
            id: 16,
            txt: ";"
        }],
        [],
        [{
            id: 17,
            txt: "entity "
        }, {
            id: 18,
            txt: "top "
        }, {
            id: 19,
            txt: "is"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 20,
            txt: "generic "
        }, {
            id: 21,
            txt: "("
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 22,
            txt: "gcnt      "
        }, {
            id: 23,
            txt: ": "
        }, {
            id: 24,
            txt: "integer "
        }, {
            id: 25,
            txt: "range "
        }, {
            id: 26,
            txt: "1 "
        }, {
            id: 27,
            txt: "to "
        }, {
            id: 28,
            txt: "4  "
        }, {
            id: 29,
            txt: ":= "
        }, {
            id: 30,
            txt: "1"
        }, {
            id: 31,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 32,
            txt: "glen      "
        }, {
            id: 33,
            txt: ": "
        }, {
            id: 34,
            txt: "integer "
        }, {
            id: 35,
            txt: "range "
        }, {
            id: 36,
            txt: "0 "
        }, {
            id: 37,
            txt: "to "
        }, {
            id: 38,
            txt: "31  "
        }, {
            id: 39,
            txt: ":= "
        }, {
            id: 40,
            txt: "0"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 41,
            txt: ")"
        }, {
            id: 42,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 43,
            txt: "port "
        }, {
            id: 44,
            txt: "("
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 45,
            txt: "clk   "
        }, {
            id: 46,
            txt: ": "
        }, {
            id: 47,
            txt: "in "
        }, {
            id: 48,
            txt: "std_logic"
        }, {
            id: 49,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 50,
            txt: "tin0  "
        }, {
            id: 51,
            txt: ": "
        }, {
            id: 52,
            txt: "in "
        }, {
            id: 53,
            txt: "std_logic_vector"
        }, {
            id: 54,
            txt: "("
        }, {
            id: 55,
            txt: "gcnt"
        }, {
            id: 56,
            txt: "-"
        }, {
            id: 57,
            txt: "1 "
        }, {
            id: 58,
            txt: "downto "
        }, {
            id: 59,
            txt: "0"
        }, {
            id: 60,
            txt: ")"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 61,
            txt: ")"
        }, {
            id: 62,
            txt: ";"
        }],
        [{
            id: 63,
            txt: "end"
        }, {
            id: 64,
            txt: ";"
        }],
        [],
        [{
            id: 65,
            txt: "architecture "
        }, {
            id: 66,
            txt: "rtl "
        }, {
            id: 67,
            txt: "of "
        }, {
            id: 68,
            txt: "top "
        }, {
            id: 69,
            txt: "is"
        }],
        [{
            id: -1,
            txt: "  "
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 70,
            txt: "type "
        }, {
            id: 71,
            txt: "vectyp "
        }, {
            id: 72,
            txt: "is "
        }, {
            id: 73,
            txt: "array "
        }, {
            id: 74,
            txt: "("
        }, {
            id: 75,
            txt: "0 "
        }, {
            id: 76,
            txt: "to "
        }, {
            id: 77,
            txt: "gcnt"
        }, {
            id: 78,
            txt: "-"
        }, {
            id: 79,
            txt: "1"
        }, {
            id: 80,
            txt: ") "
        }, {
            id: 81,
            txt: "of "
        }, {
            id: 82,
            txt: "std_logic_vector"
        }, {
            id: 83,
            txt: "("
        }, {
            id: 84,
            txt: "glen "
        }, {
            id: 85,
            txt: "downto "
        }, {
            id: 86,
            txt: "1"
        }, {
            id: 87,
            txt: ")"
        }, {
            id: 88,
            txt: ";"
        }],
        [],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 89,
            txt: "signal "
        }, {
            id: 90,
            txt: "rst "
        }, {
            id: 91,
            txt: ": "
        }, {
            id: 92,
            txt: "std_logic"
        }, {
            id: 93,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 94,
            txt: "signal "
        }, {
            id: 95,
            txt: "i0 "
        }, {
            id: 96,
            txt: ": "
        }, {
            id: 97,
            txt: "vectyp"
        }, {
            id: 98,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 99,
            txt: "signal "
        }, {
            id: 100,
            txt: "o0 "
        }, {
            id: 101,
            txt: ": "
        }, {
            id: 102,
            txt: "vectyp"
        }, {
            id: 103,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }],
        [{
            id: 104,
            txt: "begin"
        }],
        [],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 105,
            txt: "e_0"
        }, {
            id: 106,
            txt: ": "
        }, {
            id: 107,
            txt: "for "
        }, {
            id: 108,
            txt: "i "
        }, {
            id: 109,
            txt: "in "
        }, {
            id: 110,
            txt: "gcnt"
        }, {
            id: 111,
            txt: "-"
        }, {
            id: 112,
            txt: "1 "
        }, {
            id: 113,
            txt: "downto "
        }, {
            id: 114,
            txt: "0 "
        }, {
            id: 115,
            txt: "generate"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 116,
            txt: "t0 "
        }, {
            id: 117,
            txt: ": "
        }, {
            id: 118,
            txt: "e1"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 119,
            txt: "generic "
        }, {
            id: 120,
            txt: "map "
        }, {
            id: 121,
            txt: "( "
        }, {
            id: 122,
            txt: "gcnt"
        }, {
            id: 123,
            txt: ", "
        }, {
            id: 124,
            txt: "glen "
        }, {
            id: 125,
            txt: ")"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 126,
            txt: "port "
        }, {
            id: 127,
            txt: "map "
        }, {
            id: 128,
            txt: "("
        }, {
            id: 129,
            txt: "tin0"
        }, {
            id: 130,
            txt: "("
        }, {
            id: 131,
            txt: "i"
        }, {
            id: 132,
            txt: ")"
        }, {
            id: 133,
            txt: ", "
        }, {
            id: 134,
            txt: "clk"
        }, {
            id: 135,
            txt: ", "
        }, {
            id: 136,
            txt: "i0"
        }, {
            id: 137,
            txt: "("
        }, {
            id: 138,
            txt: "i"
        }, {
            id: 139,
            txt: ")"
        }, {
            id: 140,
            txt: ", "
        }, {
            id: 141,
            txt: "o0"
        }, {
            id: 142,
            txt: "("
        }, {
            id: 143,
            txt: "i"
        }, {
            id: 144,
            txt: ")"
        }, {
            id: 145,
            txt: ")"
        }, {
            id: 146,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 147,
            txt: "end "
        }, {
            id: 148,
            txt: "generate "
        }, {
            id: 149,
            txt: "e_0"
        }, {
            id: 150,
            txt: ";"
        }],
        [],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 151,
            txt: "e_1"
        }, {
            id: 152,
            txt: ": "
        }, {
            id: 153,
            txt: "if "
        }, {
            id: 154,
            txt: "gcnt"
        }, {
            id: 155,
            txt: "-"
        }, {
            id: 156,
            txt: "1 "
        }, {
            id: 157,
            txt: "= "
        }, {
            id: 158,
            txt: "1 "
        }, {
            id: 159,
            txt: "generate"
        }],
        [{
            id: -1,
            txt: "    "
        }, {
            id: 160,
            txt: "t1 "
        }, {
            id: 161,
            txt: ": "
        }, {
            id: 162,
            txt: "e1"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 163,
            txt: "generic "
        }, {
            id: 164,
            txt: "map "
        }, {
            id: 165,
            txt: "( "
        }, {
            id: 166,
            txt: "gcnt"
        }, {
            id: 167,
            txt: ", "
        }, {
            id: 168,
            txt: "glen "
        }, {
            id: 169,
            txt: ")"
        }],
        [{
            id: -1,
            txt: "      "
        }, {
            id: 170,
            txt: "port "
        }, {
            id: 171,
            txt: "map "
        }, {
            id: 172,
            txt: "("
        }, {
            id: 173,
            txt: "tin0"
        }, {
            id: 174,
            txt: "("
        }, {
            id: 175,
            txt: "0"
        }, {
            id: 176,
            txt: ")"
        }, {
            id: 177,
            txt: ", "
        }, {
            id: 178,
            txt: "clk"
        }, {
            id: 179,
            txt: ", "
        }, {
            id: 180,
            txt: "i0"
        }, {
            id: 181,
            txt: "("
        }, {
            id: 182,
            txt: "0"
        }, {
            id: 183,
            txt: ")"
        }, {
            id: 184,
            txt: ", "
        }, {
            id: 185,
            txt: "o0"
        }, {
            id: 186,
            txt: "("
        }, {
            id: 187,
            txt: "0"
        }, {
            id: 188,
            txt: ")"
        }, {
            id: 189,
            txt: ")"
        }, {
            id: 190,
            txt: ";"
        }],
        [{
            id: -1,
            txt: "  "
        }, {
            id: 191,
            txt: "end "
        }, {
            id: 192,
            txt: "generate "
        }, {
            id: 193,
            txt: "e_1"
        }, {
            id: 194,
            txt: ";"
        }],
        [],
        [{
            id: -1,
            txt: "  "
        }],
        [{
            id: 195,
            txt: "end"
        }, {
            id: 196,
            txt: ";"
        }]
    ]
};
if (typeof entities === 'undefined') {
    entities = {};
};
entities['top'] = {
    type: 'ENTITY',
    name: "top",
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
                    loc: "26"
                },
                right: {
                    type: INTLITERAL,
                    value: "4",
                    loc: "28"
                },
                dir: "to"
            },
            loc: "24"
        },
        init: {
            type: INTLITERAL,
            value: "1",
            loc: "30"
        },
        loc: "22"
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
                    loc: "36"
                },
                right: {
                    type: INTLITERAL,
                    value: "31",
                    loc: "38"
                },
                dir: "to"
            },
            loc: "34"
        },
        init: {
            type: INTLITERAL,
            value: "0",
            loc: "40"
        },
        loc: "32"
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
                    loc: "26"
                },
                right: {
                    type: INTLITERAL,
                    value: "4",
                    loc: "28"
                },
                dir: "to"
            },
            loc: "24"
        },
        init: {
            type: INTLITERAL,
            value: "1",
            loc: "30"
        },
        loc: "22"
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
                    loc: "36"
                },
                right: {
                    type: INTLITERAL,
                    value: "31",
                    loc: "38"
                },
                dir: "to"
            },
            loc: "34"
        },
        init: {
            type: INTLITERAL,
            value: "0",
            loc: "40"
        },
        loc: "32"
    }]
};
if (typeof arch === 'undefined') {
    arch = {};
};
if (typeof arch['top'] === 'undefined') {
    arch['top'] = {};
};
arch['top']['rtl'] = {
    type: ARCHITECTURE,
    name: "rtl",
    of: "top",
    decls: [{
        type: TYPEARRAY,
        name: "<vectyp>",
        range: {
            type: RANGEEXPRESSION,
            left: {
                type: INTLITERAL,
                value: "0",
                loc: "75"
            },
            right: {
                type: BINARYEXPRESSION,
                operator: MINUS,
                left: {
                    type: IDENTIFIER,
                    phase: 'name',
                    value: "gcnt",
                    loc: "77"
                },
                right: {
                    type: INTLITERAL,
                    value: "1",
                    loc: "79"
                },
                loc: "78"
            },
            dir: "to"
        }
    }, {
        type: SUBPROG,
        name: "=",
        ftyp: "function",
        arguments: [{
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPEARRAY,
                name: "<vectyp>",
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "0",
                        loc: "75"
                    },
                    right: {
                        type: BINARYEXPRESSION,
                        operator: MINUS,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "gcnt",
                            loc: "77"
                        },
                        right: {
                            type: INTLITERAL,
                            value: "1",
                            loc: "79"
                        },
                        loc: "78"
                    },
                    dir: "to"
                }
            },
            loc: "73"
        }, {
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPEARRAY,
                name: "<vectyp>",
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "0",
                        loc: "75"
                    },
                    right: {
                        type: BINARYEXPRESSION,
                        operator: MINUS,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "gcnt",
                            loc: "77"
                        },
                        right: {
                            type: INTLITERAL,
                            value: "1",
                            loc: "79"
                        },
                        loc: "78"
                    },
                    dir: "to"
                }
            },
            loc: "73"
        }],
        decl: [],
        seq: [],
        loc: "71"
    }, {
        type: SUBPROG,
        name: "/=",
        ftyp: "function",
        arguments: [{
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPEARRAY,
                name: "<vectyp>",
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "0",
                        loc: "75"
                    },
                    right: {
                        type: BINARYEXPRESSION,
                        operator: MINUS,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "gcnt",
                            loc: "77"
                        },
                        right: {
                            type: INTLITERAL,
                            value: "1",
                            loc: "79"
                        },
                        loc: "78"
                    },
                    dir: "to"
                }
            },
            loc: "73"
        }, {
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPEARRAY,
                name: "<vectyp>",
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "0",
                        loc: "75"
                    },
                    right: {
                        type: BINARYEXPRESSION,
                        operator: MINUS,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "gcnt",
                            loc: "77"
                        },
                        right: {
                            type: INTLITERAL,
                            value: "1",
                            loc: "79"
                        },
                        loc: "78"
                    },
                    dir: "to"
                }
            },
            loc: "73"
        }],
        decl: [],
        seq: [],
        loc: "71"
    }, {
        type: SUBPROG,
        name: "&",
        ftyp: "function",
        arguments: [{
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPEARRAY,
                name: "<vectyp>",
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "0",
                        loc: "75"
                    },
                    right: {
                        type: BINARYEXPRESSION,
                        operator: MINUS,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "gcnt",
                            loc: "77"
                        },
                        right: {
                            type: INTLITERAL,
                            value: "1",
                            loc: "79"
                        },
                        loc: "78"
                    },
                    dir: "to"
                }
            },
            loc: "73"
        }, {
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPEARRAY,
                name: "<vectyp>",
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "0",
                        loc: "75"
                    },
                    right: {
                        type: BINARYEXPRESSION,
                        operator: MINUS,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "gcnt",
                            loc: "77"
                        },
                        right: {
                            type: INTLITERAL,
                            value: "1",
                            loc: "79"
                        },
                        loc: "78"
                    },
                    dir: "to"
                }
            },
            loc: "73"
        }],
        decl: [],
        seq: [],
        loc: "71"
    }, {
        type: SUBPROG,
        name: "&",
        ftyp: "function",
        arguments: [{
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPECONSTRAINEDARRAY,
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: IDENTIFIER,
                        phase: 'name',
                        value: "glen",
                        loc: "84"
                    },
                    right: {
                        type: INTLITERAL,
                        value: "1",
                        loc: "86"
                    },
                    dir: "downto"
                },
                typmark: "std_logic_vector",
                loc: "83"
            },
            loc: "83"
        }, {
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPEARRAY,
                name: "<vectyp>",
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "0",
                        loc: "75"
                    },
                    right: {
                        type: BINARYEXPRESSION,
                        operator: MINUS,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "gcnt",
                            loc: "77"
                        },
                        right: {
                            type: INTLITERAL,
                            value: "1",
                            loc: "79"
                        },
                        loc: "78"
                    },
                    dir: "to"
                }
            },
            loc: "73"
        }],
        decl: [],
        seq: [],
        loc: "71"
    }, {
        type: SUBPROG,
        name: "&",
        ftyp: "function",
        arguments: [{
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPEARRAY,
                name: "<vectyp>",
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: INTLITERAL,
                        value: "0",
                        loc: "75"
                    },
                    right: {
                        type: BINARYEXPRESSION,
                        operator: MINUS,
                        left: {
                            type: IDENTIFIER,
                            phase: 'name',
                            value: "gcnt",
                            loc: "77"
                        },
                        right: {
                            type: INTLITERAL,
                            value: "1",
                            loc: "79"
                        },
                        loc: "78"
                    },
                    dir: "to"
                }
            },
            loc: "73"
        }, {
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPECONSTRAINEDARRAY,
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: IDENTIFIER,
                        phase: 'name',
                        value: "glen",
                        loc: "84"
                    },
                    right: {
                        type: INTLITERAL,
                        value: "1",
                        loc: "86"
                    },
                    dir: "downto"
                },
                typmark: "std_logic_vector",
                loc: "83"
            },
            loc: "83"
        }],
        decl: [],
        seq: [],
        loc: "71"
    }, {
        type: SUBPROG,
        name: "&",
        ftyp: "function",
        arguments: [{
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPECONSTRAINEDARRAY,
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: IDENTIFIER,
                        phase: 'name',
                        value: "glen",
                        loc: "84"
                    },
                    right: {
                        type: INTLITERAL,
                        value: "1",
                        loc: "86"
                    },
                    dir: "downto"
                },
                typmark: "std_logic_vector",
                loc: "83"
            },
            loc: "83"
        }, {
            type: ARG,
            name: "<anonymous>",
            mode: "in ",
            typedef: {
                type: TYPECONSTRAINEDARRAY,
                range: {
                    type: RANGEEXPRESSION,
                    left: {
                        type: IDENTIFIER,
                        phase: 'name',
                        value: "glen",
                        loc: "84"
                    },
                    right: {
                        type: INTLITERAL,
                        value: "1",
                        loc: "86"
                    },
                    dir: "downto"
                },
                typmark: "std_logic_vector",
                loc: "83"
            },
            loc: "83"
        }],
        decl: [],
        seq: [],
        loc: "71"
    }, {
        type: TYPECONSTRAINEDARRAY,
        name: "vectyp",
        range: {
            type: RANGEEXPRESSION,
            left: {
                type: INTLITERAL,
                value: "0",
                loc: "75"
            },
            right: {
                type: BINARYEXPRESSION,
                operator: MINUS,
                left: {
                    type: IDENTIFIER,
                    phase: 'name',
                    value: "gcnt",
                    loc: "77"
                },
                right: {
                    type: INTLITERAL,
                    value: "1",
                    loc: "79"
                },
                loc: "78"
            },
            dir: "to"
        },
        typmark: "<vectyp>"
    }, {
        type: SIGNAL,
        name: "rst",
        typdef: {
            type: TYPEENUM,
            name: "std_logic"
        },
        loc: "90"
    }, {
        type: SIGNAL,
        name: "i0",
        typdef: {
            type: TYPECONSTRAINEDARRAY,
            name: "vectyp",
            range: {
                type: RANGEEXPRESSION,
                left: {
                    type: INTLITERAL,
                    value: "0",
                    loc: "75"
                },
                right: {
                    type: BINARYEXPRESSION,
                    operator: MINUS,
                    left: {
                        type: IDENTIFIER,
                        phase: 'name',
                        value: "gcnt",
                        loc: "77"
                    },
                    right: {
                        type: INTLITERAL,
                        value: "1",
                        loc: "79"
                    },
                    loc: "78"
                },
                dir: "to"
            },
            typmark: "<vectyp>"
        },
        loc: "95"
    }, {
        type: SIGNAL,
        name: "o0",
        typdef: {
            type: TYPECONSTRAINEDARRAY,
            name: "vectyp",
            range: {
                type: RANGEEXPRESSION,
                left: {
                    type: INTLITERAL,
                    value: "0",
                    loc: "75"
                },
                right: {
                    type: BINARYEXPRESSION,
                    operator: MINUS,
                    left: {
                        type: IDENTIFIER,
                        phase: 'name',
                        value: "gcnt",
                        loc: "77"
                    },
                    right: {
                        type: INTLITERAL,
                        value: "1",
                        loc: "79"
                    },
                    loc: "78"
                },
                dir: "to"
            },
            typmark: "<vectyp>"
        },
        loc: "100"
    }],
    procs: [],
    concs: [{
        type: GENERATE,
        cond: "for",
        decls: [{
            type: COMPONENT,
            generics: [{
                type: ASSOCIATION,
                value: {
                    type: IDENTIFIER,
                    phase: 'name',
                    value: "gcnt",
                    loc: "122"
                },
                loc: "123"
            }, {
                type: ASSOCIATION,
                value: {
                    type: IDENTIFIER,
                    phase: 'name',
                    value: "glen",
                    loc: "124"
                },
                loc: "123"
            }],
            ports: [{
                type: ASSOCIATION,
                value: {
                    type: INDEXEXPRESSION,
                    object: {
                        type: IDENTIFIER,
                        phase: 'sig',
                        value: "tin0",
                        loc: "50"
                    },
                    indexes: [{
                        type: IDENTIFIER,
                        phase: 'name',
                        value: "i",
                        loc: "131"
                    }],
                    loc: "130"
                },
                loc: "133"
            }, {
                type: ASSOCIATION,
                value: {
                    type: IDENTIFIER,
                    phase: 'name',
                    value: "clk",
                    loc: "134"
                },
                loc: "133"
            }, {
                type: ASSOCIATION,
                value: {
                    type: INDEXEXPRESSION,
                    object: {
                        type: IDENTIFIER,
                        phase: 'sig',
                        value: "i0",
                        loc: "95"
                    },
                    indexes: [{
                        type: IDENTIFIER,
                        phase: 'name',
                        value: "i",
                        loc: "138"
                    }],
                    loc: "137"
                },
                loc: "133"
            }, {
                type: ASSOCIATION,
                value: {
                    type: INDEXEXPRESSION,
                    object: {
                        type: IDENTIFIER,
                        phase: 'sig',
                        value: "o0",
                        loc: "100"
                    },
                    indexes: [{
                        type: IDENTIFIER,
                        phase: 'name',
                        value: "i",
                        loc: "143"
                    }],
                    loc: "142"
                },
                loc: "133"
            }]
        }],
        conditional: {
            type: LOOPPARAM,
            name: "i",
            range: {
                type: RANGEEXPRESSION,
                left: {
                    type: BINARYEXPRESSION,
                    operator: MINUS,
                    left: {
                        type: IDENTIFIER,
                        phase: 'name',
                        value: "gcnt",
                        loc: "110"
                    },
                    right: {
                        type: INTLITERAL,
                        value: "1",
                        loc: "112"
                    },
                    loc: "111"
                },
                right: {
                    type: INTLITERAL,
                    value: "0",
                    loc: "114"
                },
                dir: "downto"
            }
        },
        loc: "105"
    }, {
        type: GENERATE,
        cond: "if",
        decls: [{
            type: COMPONENT,
            generics: [{
                type: ASSOCIATION,
                value: {
                    type: IDENTIFIER,
                    phase: 'name',
                    value: "gcnt",
                    loc: "166"
                },
                loc: "167"
            }, {
                type: ASSOCIATION,
                value: {
                    type: IDENTIFIER,
                    phase: 'name',
                    value: "glen",
                    loc: "168"
                },
                loc: "167"
            }],
            ports: [{
                type: ASSOCIATION,
                value: {
                    type: INDEXEXPRESSION,
                    object: {
                        type: IDENTIFIER,
                        phase: 'sig',
                        value: "tin0",
                        loc: "50"
                    },
                    indexes: [{
                        type: INTLITERAL,
                        value: "0",
                        loc: "175"
                    }],
                    loc: "174"
                },
                loc: "177"
            }, {
                type: ASSOCIATION,
                value: {
                    type: IDENTIFIER,
                    phase: 'name',
                    value: "clk",
                    loc: "178"
                },
                loc: "177"
            }, {
                type: ASSOCIATION,
                value: {
                    type: INDEXEXPRESSION,
                    object: {
                        type: IDENTIFIER,
                        phase: 'sig',
                        value: "i0",
                        loc: "95"
                    },
                    indexes: [{
                        type: INTLITERAL,
                        value: "0",
                        loc: "182"
                    }],
                    loc: "181"
                },
                loc: "177"
            }, {
                type: ASSOCIATION,
                value: {
                    type: INDEXEXPRESSION,
                    object: {
                        type: IDENTIFIER,
                        phase: 'sig',
                        value: "o0",
                        loc: "100"
                    },
                    indexes: [{
                        type: INTLITERAL,
                        value: "0",
                        loc: "187"
                    }],
                    loc: "186"
                },
                loc: "177"
            }]
        }],
        conditional: {
            type: BINARYEXPRESSION,
            operator: EQ,
            left: {
                type: BINARYEXPRESSION,
                operator: MINUS,
                left: {
                    type: IDENTIFIER,
                    phase: 'name',
                    value: "gcnt",
                    loc: "154"
                },
                right: {
                    type: INTLITERAL,
                    value: "1",
                    loc: "156"
                },
                loc: "155"
            },
            right: {
                type: INTLITERAL,
                value: "1",
                loc: "158"
            },
            loc: "157"
        },
        loc: "151"
    }]
};
