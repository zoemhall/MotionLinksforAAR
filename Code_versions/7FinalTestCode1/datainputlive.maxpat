{
    "patcher": {
        "fileversion": 1,
        "appversion": {
            "major": 9,
            "minor": 1,
            "revision": 4,
            "architecture": "x64",
            "modernui": 1
        },
        "classnamespace": "box",
        "rect": [ 34.0, 95.0, 1011.0, 765.0 ],
        "boxes": [
            {
                "box": {
                    "format": 6,
                    "id": "obj-9",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 184.96238958835602, 509.02251118421555, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-7",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 193.98494517803192, 590.9773911237717, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-1",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 180.93, 542.8570946455002, 110.0, 22.0 ],
                    "text": "scale 0. 1023. 0. 1."
                }
            },
            {
                "box": {
                    "fontface": 0,
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-17",
                    "maxclass": "number~",
                    "mode": 2,
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "float" ],
                    "patching_rect": [ 180.93, 426.71758675575256, 56.0, 22.0 ],
                    "sig": 0.0
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 180.93, 389.38, 31.0, 22.0 ],
                    "text": "sig~"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-4",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 290.7562851905823, 402.1008163690567, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-48",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 803.2863955100379, 396.4071806669235, 150.0, 33.0 ],
                    "text": "if these values are above 1, it is essentially a step!!!"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-31",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1003.2863981326423, 319.83839333057404, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-34",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 937.0892141660056, 319.83839333057404, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-35",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 870.1878048380217, 319.83839333057404, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-38",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 803.2863955100379, 319.83839333057404, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-26",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1003.521139919758, 285.9154967069626, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-20",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 936.8544723788898, 285.9154967069626, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-16",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 870.1878048380216, 285.9154967069626, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-10",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 803.5211372971535, 285.9154967069626, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-15",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 494.3339467048645, 90.0, 152.27271384000778, 20.0 ],
                    "text": "datainput subpatch"
                }
            },
            {
                "box": {
                    "id": "obj-30",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1291.0, 341.0, 56.0, 22.0 ],
                    "text": "scaling 1"
                }
            },
            {
                "box": {
                    "id": "obj-82",
                    "maxclass": "ezdac~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 840.4761824607849, 212.5, 45.0, 45.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-73",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 265.4040274322033, 261.3333411216736, 90.15151074528694, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-74",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 266.6666536331177, 230.00000685453415, 88.3838340640068, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-71",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 269.2234716899693, 350.6666771173477, 86.33206648752093, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-70",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 268.24493638426065, 319.3333428502083, 87.31060179322958, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-69",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 267.29796673357487, 288.00000858306885, 87.75252096354961, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-66",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 410.372340708971, 509.5, 79.25531858205795, 20.0 ],
                    "text": "elapsed time"
                }
            },
            {
                "box": {
                    "id": "obj-57",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 659.9905042648315, 345.5, 31.0, 22.0 ],
                    "text": "sig~"
                }
            },
            {
                "box": {
                    "fontface": 0,
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-59",
                    "interval": 250.0,
                    "maxclass": "number~",
                    "mode": 2,
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "float" ],
                    "patching_rect": [ 670.0915138721466, 369.5000110268593, 59.0, 23.0 ],
                    "sig": 0.0
                }
            },
            {
                "box": {
                    "id": "obj-55",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 579.3401929608981, 345.5, 31.0, 22.0 ],
                    "text": "sig~"
                }
            },
            {
                "box": {
                    "fontface": 0,
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-56",
                    "interval": 250.0,
                    "maxclass": "number~",
                    "mode": 2,
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "float" ],
                    "patching_rect": [ 589.7884874939919, 369.5000110268593, 59.0, 23.0 ],
                    "sig": 0.0
                }
            },
            {
                "box": {
                    "id": "obj-54",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 483.7278866171837, 345.5, 31.0, 22.0 ],
                    "text": "sig~"
                }
            },
            {
                "box": {
                    "fontface": 0,
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-53",
                    "interval": 250.0,
                    "maxclass": "number~",
                    "mode": 2,
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "float" ],
                    "patching_rect": [ 494.3339467048645, 369.5000110268593, 59.0, 23.0 ],
                    "sig": 0.0
                }
            },
            {
                "box": {
                    "fontface": 0,
                    "fontname": "Arial",
                    "fontsize": 13.0,
                    "id": "obj-3",
                    "interval": 250.0,
                    "maxclass": "number~",
                    "mode": 2,
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "float" ],
                    "patching_rect": [ 414.7058576345444, 358.8235080242157, 59.0, 23.0 ],
                    "sig": 0.6213592233009708
                }
            },
            {
                "box": {
                    "id": "obj-52",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 393.9866666666667, 319.3333428502083, 31.0, 22.0 ],
                    "text": "sig~"
                }
            },
            {
                "box": {
                    "comment": "",
                    "id": "obj-47",
                    "index": 1,
                    "maxclass": "outlet",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 378.5, 504.5, 30.0, 30.0 ]
                }
            },
            {
                "box": {
                    "comment": "",
                    "id": "obj-46",
                    "index": 5,
                    "maxclass": "outlet",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 659.9905042648315, 459.5959371328354, 30.0, 30.0 ]
                }
            },
            {
                "box": {
                    "comment": "",
                    "id": "obj-45",
                    "index": 4,
                    "maxclass": "outlet",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 579.182427406311, 459.5959371328354, 30.0, 30.0 ]
                }
            },
            {
                "box": {
                    "comment": "",
                    "id": "obj-44",
                    "index": 3,
                    "maxclass": "outlet",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 483.22283613681793, 459.5959371328354, 30.0, 30.0 ]
                }
            },
            {
                "box": {
                    "comment": "",
                    "id": "obj-43",
                    "index": 2,
                    "maxclass": "outlet",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 394.3339515924454, 463.13129049539566, 30.0, 30.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-42",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 659.9905042648315, 319.83839333057404, 110.0, 22.0 ],
                    "text": "scale 0. 1023. 0. 1."
                }
            },
            {
                "box": {
                    "id": "obj-41",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 579.3401929608981, 288.00000858306885, 110.0, 22.0 ],
                    "text": "scale 0. 1023. 0. 1."
                }
            },
            {
                "box": {
                    "id": "obj-40",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 483.7278866171837, 319.3333428502083, 110.0, 22.0 ],
                    "text": "scale 0. 1023. 0. 1."
                }
            },
            {
                "box": {
                    "id": "obj-24",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 393.9866666666667, 288.00000858306885, 110.0, 22.0 ],
                    "text": "scale 0. 1023. 0. 1."
                }
            },
            {
                "box": {
                    "id": "obj-37",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 690.8339515924454, 464.13129049539566, 84.66666918992996, 20.0 ],
                    "text": "R heel"
                }
            },
            {
                "box": {
                    "id": "obj-36",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1922.058786869049, 2179.411723136902, 150.0, 20.0 ],
                    "text": "hehe"
                }
            },
            {
                "box": {
                    "id": "obj-33",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 610.3339515924454, 464.13129049539566, 75.31998444318765, 20.0 ],
                    "text": "R toe"
                }
            },
            {
                "box": {
                    "id": "obj-32",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 514.8339515924454, 464.63129049539566, 75.31998444318765, 20.0 ],
                    "text": "L heel"
                }
            },
            {
                "box": {
                    "id": "obj-25",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 426.3339515924454, 468.13129049539566, 69.33333539962769, 20.0 ],
                    "text": "L toe"
                }
            },
            {
                "box": {
                    "id": "obj-28",
                    "linecount": 4,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 612.2298003781759, 205.0, 221.0, 60.0 ],
                    "text": "counter, time elapsed, left foot toe, left foor heel, right foot toe, right foot heel, left foot toe lower bound, left foot toe upper bound, etc. etc. "
                }
            },
            {
                "box": {
                    "id": "obj-12",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 14,
                    "outlettype": [ "float", "float", "int", "int", "int", "int", "float", "float", "float", "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 362.96153846153845, 243.0, 221.0, 22.0 ],
                    "text": "unpack 0. 0. 0 0 0 0 0. 0. 0. 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "comment": "",
                    "id": "obj-5",
                    "index": 1,
                    "maxclass": "inlet",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 362.96153846153845, 204.99999943375587, 30.0, 30.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-2",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 496.51577365398407, 136.0, 152.27271384000778, 33.0 ],
                    "text": "converting prerecorded data into the signal stream"
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "source": [ "obj-1", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10", 0 ],
                    "order": 0,
                    "source": [ "obj-12", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-16", 0 ],
                    "midpoints": [ 496.7692307692308, 276.0, 789.0, 276.0, 789.0, 282.0, 879.6878048380216, 282.0 ],
                    "order": 0,
                    "source": [ "obj-12", 8 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20", 0 ],
                    "midpoints": [ 527.8461538461538, 276.0, 597.0, 276.0, 597.0, 192.0, 946.3544723788898, 192.0 ],
                    "order": 0,
                    "source": [ "obj-12", 10 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-24", 2 ],
                    "order": 1,
                    "source": [ "obj-12", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-24", 1 ],
                    "order": 1,
                    "source": [ "obj-12", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-24", 0 ],
                    "midpoints": [ 403.53846153846155, 273.4711540872231, 405.0, 273.4711540872231, 405.0, 285.0, 403.4866666666667, 285.0 ],
                    "order": 0,
                    "source": [ "obj-12", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 0 ],
                    "order": 0,
                    "source": [ "obj-12", 12 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-31", 0 ],
                    "midpoints": [ 574.4615384615385, 275.2333337627351, 597.0, 275.2333337627351, 597.0, 275.40564962121425, 999.0, 275.40564962121425, 999.0, 312.0, 1012.7863981326423, 312.0 ],
                    "order": 0,
                    "source": [ "obj-12", 13 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-34", 0 ],
                    "midpoints": [ 543.3846153846154, 275.6791671193205, 597.0, 275.6791671193205, 597.0, 275.5772458142601, 933.0, 275.5772458142601, 933.0, 312.0, 946.5892141660056, 312.0 ],
                    "order": 0,
                    "source": [ "obj-12", 11 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-35", 0 ],
                    "midpoints": [ 512.3076923076923, 276.0, 789.0, 276.0, 789.0, 315.0, 879.6878048380217, 315.0 ],
                    "order": 0,
                    "source": [ "obj-12", 9 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-38", 0 ],
                    "midpoints": [ 481.2307692307692, 276.0, 789.0, 276.0, 789.0, 315.0, 812.7863955100379, 315.0 ],
                    "order": 0,
                    "source": [ "obj-12", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-40", 2 ],
                    "order": 1,
                    "source": [ "obj-12", 9 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-40", 1 ],
                    "order": 1,
                    "source": [ "obj-12", 8 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-40", 0 ],
                    "midpoints": [ 419.0769230769231, 276.088281206612, 509.173828125, 276.088281206612, 509.173828125, 306.0, 493.2278866171837, 306.0 ],
                    "order": 0,
                    "source": [ "obj-12", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-41", 2 ],
                    "order": 1,
                    "source": [ "obj-12", 11 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-41", 1 ],
                    "order": 1,
                    "source": [ "obj-12", 10 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-41", 0 ],
                    "midpoints": [ 434.61538461538464, 276.0, 588.8401929608981, 276.0 ],
                    "order": 0,
                    "source": [ "obj-12", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-42", 2 ],
                    "midpoints": [ 574.4615384615385, 275.98750046873465, 597.0, 275.98750046873465, 597.0, 276.0, 705.8905042648315, 276.0 ],
                    "order": 1,
                    "source": [ "obj-12", 13 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-42", 1 ],
                    "midpoints": [ 558.9230769230769, 306.0, 576.0, 306.0, 576.0, 315.0, 687.6905042648316, 315.0 ],
                    "order": 1,
                    "source": [ "obj-12", 12 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-42", 0 ],
                    "midpoints": [ 450.15384615384613, 276.0, 564.0, 276.0, 564.0, 315.0, 669.4905042648315, 315.0 ],
                    "order": 0,
                    "source": [ "obj-12", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-47", 0 ],
                    "order": 0,
                    "source": [ "obj-12", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-69", 0 ],
                    "midpoints": [ 419.0769230769231, 275.7484376303619, 378.0, 275.7484376303619, 378.0, 285.0, 276.79796673357487, 285.0 ],
                    "order": 1,
                    "source": [ "obj-12", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-70", 0 ],
                    "midpoints": [ 434.61538461538464, 275.6796876293374, 378.0, 275.6796876293374, 378.0, 315.0, 277.74493638426065, 315.0 ],
                    "order": 1,
                    "source": [ "obj-12", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-71", 0 ],
                    "midpoints": [ 450.15384615384613, 275.8632813820732, 378.0, 275.8632813820732, 378.0, 345.0, 278.7234716899693, 345.0 ],
                    "order": 1,
                    "source": [ "obj-12", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-73", 0 ],
                    "midpoints": [ 403.53846153846155, 274.4679688612814, 357.0, 274.4679688612814, 357.0, 258.0, 274.9040274322033, 258.0 ],
                    "order": 1,
                    "source": [ "obj-12", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-74", 0 ],
                    "midpoints": [ 388.0, 274.2796876084758, 357.0, 274.2796876084758, 357.0, 216.0, 276.1666536331177, 216.0 ],
                    "order": 1,
                    "source": [ "obj-12", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-17", 0 ],
                    "source": [ "obj-14", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4", 0 ],
                    "order": 1,
                    "source": [ "obj-24", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-52", 0 ],
                    "order": 0,
                    "source": [ "obj-24", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-54", 0 ],
                    "source": [ "obj-40", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-55", 0 ],
                    "source": [ "obj-41", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-57", 0 ],
                    "source": [ "obj-42", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-12", 0 ],
                    "source": [ "obj-5", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-3", 0 ],
                    "order": 0,
                    "source": [ "obj-52", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-43", 0 ],
                    "order": 1,
                    "source": [ "obj-52", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-44", 0 ],
                    "order": 1,
                    "source": [ "obj-54", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-53", 0 ],
                    "order": 0,
                    "source": [ "obj-54", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-45", 0 ],
                    "order": 1,
                    "source": [ "obj-55", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-56", 0 ],
                    "order": 0,
                    "source": [ "obj-55", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-46", 0 ],
                    "order": 1,
                    "source": [ "obj-57", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-59", 0 ],
                    "order": 0,
                    "source": [ "obj-57", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-14", 0 ],
                    "source": [ "obj-69", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-1", 0 ],
                    "source": [ "obj-9", 0 ]
                }
            }
        ]
    }
}