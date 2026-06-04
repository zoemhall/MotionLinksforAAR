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
        "rect": [ 34.0, 95.0, 1002.0, 762.0 ],
        "boxes": [
            {
                "box": {
                    "id": "obj-11",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1138.888943195343, 2177.7778816223145, 29.5, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-12",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1111.1111640930176, 2177.7778816223145, 29.5, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1319.4445073604584, 2141.6667687892914, 43.0, 22.0 ],
                    "text": "reverb"
                }
            },
            {
                "box": {
                    "id": "obj-15",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1119.4444978237152, 2141.6667687892914, 43.0, 22.0 ],
                    "text": "reverb"
                }
            },
            {
                "box": {
                    "id": "obj-1",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 777.7778148651123, 1733.3334159851074, 51.401868760585785, 20.0 ],
                    "text": "6 (on)"
                }
            },
            {
                "box": {
                    "id": "obj-3",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 638.8889193534851, 1758.3334171772003, 51.401868760585785, 20.0 ],
                    "text": "-70 (off)"
                }
            },
            {
                "box": {
                    "id": "obj-4",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 738.8889241218567, 1727.7778601646423, 29.5, 22.0 ],
                    "text": "6"
                }
            },
            {
                "box": {
                    "id": "obj-5",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 702.7778112888336, 1758.3334171772003, 29.5, 22.0 ],
                    "text": "-70"
                }
            },
            {
                "box": {
                    "id": "obj-6",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 738.8889241218567, 1688.8889694213867, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-8",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 702.7778112888336, 1688.8889694213867, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-9",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "" ],
                    "patching_rect": [ 702.7778112888336, 1636.1111891269684, 34.0, 22.0 ],
                    "text": "sel 0"
                }
            },
            {
                "box": {
                    "id": "obj-2",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ -1191.3793728351593, 1256.8966176509857, 150.0, 20.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-158",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 647.8260746002197, 852.1738967895508, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 647.8260746002197, 821.7391147613525, 32.0, 22.0 ],
                    "text": "gate"
                }
            },
            {
                "box": {
                    "id": "obj-48",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 552.1739025115967, 926.0869388580322, 29.5, 22.0 ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "fontface": 0,
                    "fontname": "Arial",
                    "fontsize": 12.0,
                    "id": "obj-163",
                    "maxclass": "number~",
                    "mode": 2,
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "float" ],
                    "patching_rect": [ 1711.111192703247, 1747.2223055362701, 56.0, 22.0 ],
                    "sig": 0.0
                }
            },
            {
                "box": {
                    "id": "obj-162",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1669.444524049759, 1741.666749715805, 31.0, 22.0 ],
                    "text": "sig~"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-161",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1608.333410024643, 1733.3334159851074, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-159",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1277.7778387069702, 1772.222306728363, 103.0, 33.0 ],
                    "text": "button if its being weird saving data"
                }
            },
            {
                "box": {
                    "id": "obj-31",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1425.000067949295, 2033.3334302902222, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-60",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1411.1111783981323, 1997.222317457199, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-126",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1388.888955116272, 1997.222317457199, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-128",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1402.7778446674347, 2033.3334302902222, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-132",
                    "linecount": 3,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1386.1111772060394, 2105.5556559562683, 153.0, 47.0 ],
                    "text": "after signal condition so that it is triggered by sharp spikes"
                }
            },
            {
                "box": {
                    "id": "obj-135",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 702.7778112888336, 1605.5556321144104, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-143",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 8,
                    "outlettype": [ "", "", "", "", "bang", "bang", "bang", "bang" ],
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
                        "rect": [ 34.0, 95.0, 1402.0, 762.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-45",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "int", "int" ],
                                    "patching_rect": [ 779.8318862915039, 756.3024759292603, 61.0, 22.0 ],
                                    "text": "change 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "int", "int" ],
                                    "patching_rect": [ 820.1680183410645, 712.6049995422363, 61.0, 22.0 ],
                                    "text": "change 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "int", "int" ],
                                    "patching_rect": [ 859.6638143062592, 756.3024759292603, 61.0, 22.0 ],
                                    "text": "change 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1914.3791454434395, 1530.7190026044846, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "int", "int" ],
                                    "patching_rect": [ 898.319274187088, 712.6049995422363, 61.0, 22.0 ],
                                    "text": "change 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 363.0, 55.0, 150.0, 20.0 ],
                                    "text": "triggers sub patch"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-184",
                                    "maxclass": "toggle",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1268.5714852809906, 483.42859303951263, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-182",
                                    "maxclass": "toggle",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1100.000049173832, 449.1428772211075, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-178",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 1194.8571962714195, 450.4648605585098, 34.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-179",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1194.8571962714195, 421.89343070983887, 29.5, 22.0 ],
                                    "text": ">"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-180",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1194.8571962714195, 477.89343321323395, 29.5, 22.0 ],
                                    "text": "1."
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-177",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1158.5000513195992, 352.0000157356262, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-172",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 1148.0000513195992, 410.02756655216217, 34.0, 22.0 ],
                                    "text": "sel 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-173",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 1148.0000513195992, 381.4561367034912, 29.5, 22.0 ],
                                    "text": "<"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-174",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1148.0000513195992, 437.4561392068863, 29.5, 22.0 ],
                                    "text": "0."
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-175",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1148.0000513195992, 559.1704303622246, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-170",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1137.7143365740776, 229.0322597026825, 29.5, 22.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-168",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1137.7143365740776, 262.2857260107994, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-163",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1148.0000513195992, 322.85715728998184, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-166",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "float" ],
                                    "patching_rect": [ 1137.7143365740776, 288.5714414715767, 29.5, 22.0 ],
                                    "text": "t b f"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-160",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1024.5714743733406, 341.7143009901047, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-158",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1060.7857612371445, 381.4561367034912, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-156",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1060.7857612371445, 343.6731775403023, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-154",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1050.3000000000002, 248.00001108646393, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-152",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1050.3000000000002, 277.87, 29.5, 22.0 ],
                                    "text": "1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-150",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "float" ],
                                    "patching_rect": [ 1050.2857612371445, 309.1428709626198, 29.5, 22.0 ],
                                    "text": "t b f"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-107",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 681.1475214958191, 392.39343070983887, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-108",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 681.1475214958191, 343.6731775403023, 81.0, 22.0 ],
                                    "text": "snapshot~ 10"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-105",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 557.3770332336426, 392.39343070983887, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-106",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 557.3770332336426, 343.12799644470215, 81.0, 22.0 ],
                                    "text": "snapshot~ 10"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-103",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 449.1803150177002, 392.39343070983887, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-104",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 449.1803150177002, 343.12799644470215, 81.0, 22.0 ],
                                    "text": "snapshot~ 10"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-102",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 340.1639246940613, 392.39343070983887, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-99",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 371.9312119483948, 229.0322597026825, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-100",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 371.9312119483948, 203.22580790519714, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-98",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 541.2860518693924, 229.0322597026825, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-97",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 541.2860518693924, 203.22580790519714, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-96",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 340.1639246940613, 343.12799644470215, 81.0, 22.0 ],
                                    "text": "snapshot~ 10"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-87",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "multichannelsignal" ],
                                    "patching_rect": [ 443.7054060101509, 123.38709765672684, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-86",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 443.7054060101509, 171.77419477701187, 84.0, 22.0 ],
                                    "text": "mc.unpack~ 4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-85",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 919.3276762962341, 804.2016327381134, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-83",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 880.6722164154053, 804.2016327381134, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-81",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 842.0167565345764, 804.2016327381134, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-79",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 800.84028840065, 804.2016327381134, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-77",
                                    "index": 8,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 919.3276762962341, 840.3360843658447, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-76",
                                    "index": 7,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 880.6722164154053, 840.3360843658447, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-75",
                                    "index": 6,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 842.0167565345764, 840.3360843658447, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-74",
                                    "index": 5,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 800.84028840065, 840.3360843658447, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 690.9090299606323, 503.0302586555481, 34.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-62",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 690.9090299606323, 474.2423824071884, 36.0, 22.0 ],
                                    "text": "< 1.1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-63",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 690.9090299606323, 530.3029835224152, 29.5, 22.0 ],
                                    "text": "0."
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-64",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 690.9090299606323, 652.2726697325706, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 723.4847846627235, 617.4241879582405, 29.5, 22.0 ],
                                    "text": "1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-66",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 722.7272089719772, 581.8181304931641, 34.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-67",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 722.7272089719772, 555.3029813170433, 42.0, 22.0 ],
                                    "text": "> 1.92"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-54",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 568.9393437504768, 503.0302586555481, 34.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 568.9393437504768, 474.2423824071884, 36.0, 22.0 ],
                                    "text": "< 1.1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-56",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 568.9393437504768, 530.3029835224152, 29.5, 22.0 ],
                                    "text": "0."
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-57",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 568.1817680597305, 652.2726697325706, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 601.515098452568, 617.4241879582405, 29.5, 22.0 ],
                                    "text": "1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 600.7575227618217, 581.0605548024178, 34.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 600.7575227618217, 555.3029813170433, 42.0, 22.0 ],
                                    "text": "> 1.92"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-47",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 459.09086859226227, 503.0302586555481, 34.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-48",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 459.09086859226227, 474.2423824071884, 36.0, 22.0 ],
                                    "text": "< 1.1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-49",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 459.09086859226227, 532.5757105946541, 29.5, 22.0 ],
                                    "text": "0."
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-50",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 459.09086859226227, 652.2726697325706, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 490.9090476036072, 618.1817636489868, 29.5, 22.0 ],
                                    "text": "1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 490.9090476036072, 581.8181304931641, 34.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-53",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 490.9090476036072, 556.0605570077896, 29.5, 22.0 ],
                                    "text": "> 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 350.7575448155403, 503.0302586555481, 34.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-41",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 350.7575448155403, 474.2423824071884, 36.0, 22.0 ],
                                    "text": "< 1.1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-40",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 350.7575448155403, 530.3029835224152, 29.5, 22.0 ],
                                    "text": "0."
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
                                    "patching_rect": [ 350.7575448155403, 652.2726697325706, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-36",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 383.33329951763153, 618.1817636489868, 29.5, 22.0 ],
                                    "text": "1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-34",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 382.5757238268852, 581.8181304931641, 34.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-33",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 382.5757238268852, 555.3029813170433, 42.0, 22.0 ],
                                    "text": "> 1.92"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-32",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "float", "float" ],
                                    "patching_rect": [ 681.1475214958191, 416.39343070983887, 40.0, 22.0 ],
                                    "text": "t b f f"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-31",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "float", "float" ],
                                    "patching_rect": [ 557.3770332336426, 415.57375860214233, 40.0, 22.0 ],
                                    "text": "t b f f"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-30",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "float", "float" ],
                                    "patching_rect": [ 449.1803150177002, 416.39343070983887, 40.0, 22.0 ],
                                    "text": "t b f f"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "float", "float" ],
                                    "patching_rect": [ 340.1639246940613, 416.39343070983887, 40.0, 22.0 ],
                                    "text": "t b f f"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-28",
                                    "index": 4,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 690.9090299606323, 692.4241813421249, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-27",
                                    "index": 3,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 568.1817680597305, 692.4241813421249, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-26",
                                    "index": 2,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 459.09086859226227, 692.4241813421249, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-25",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 350.7575448155403, 692.4241813421249, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 349.999969124794, 736.3635714054108, 370.0854738354683, 20.0 ],
                                    "text": "outputs either 1 or 0 for true or false."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 776.3157820701599, 410.89343070983887, 226.0, 33.0 ],
                                    "text": "left foot toe, left foor heel, right foot toe, right foot heel"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 776.3157820701599, 382.4561367034912, 226.0, 20.0 ],
                                    "text": "pressure values"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-29", 0 ],
                                    "source": [ "obj-102", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-30", 0 ],
                                    "source": [ "obj-103", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-103", 0 ],
                                    "source": [ "obj-104", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-31", 0 ],
                                    "source": [ "obj-105", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-105", 0 ],
                                    "source": [ "obj-106", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-32", 0 ],
                                    "source": [ "obj-107", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-107", 0 ],
                                    "source": [ "obj-108", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-156", 0 ],
                                    "source": [ "obj-150", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-160", 0 ],
                                    "source": [ "obj-150", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-150", 0 ],
                                    "source": [ "obj-152", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-152", 0 ],
                                    "source": [ "obj-154", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-158", 0 ],
                                    "source": [ "obj-156", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-156", 0 ],
                                    "source": [ "obj-160", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-173", 0 ],
                                    "order": 1,
                                    "source": [ "obj-163", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-179", 0 ],
                                    "order": 0,
                                    "source": [ "obj-163", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-163", 0 ],
                                    "source": [ "obj-166", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-166", 0 ],
                                    "source": [ "obj-168", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-168", 0 ],
                                    "source": [ "obj-170", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-174", 0 ],
                                    "source": [ "obj-172", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-172", 0 ],
                                    "order": 0,
                                    "source": [ "obj-173", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-182", 0 ],
                                    "order": 1,
                                    "source": [ "obj-173", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-175", 0 ],
                                    "source": [ "obj-174", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-173", 1 ],
                                    "order": 1,
                                    "source": [ "obj-177", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-179", 1 ],
                                    "order": 0,
                                    "source": [ "obj-177", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-180", 0 ],
                                    "source": [ "obj-178", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-178", 0 ],
                                    "order": 1,
                                    "source": [ "obj-179", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-184", 0 ],
                                    "order": 0,
                                    "source": [ "obj-179", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-175", 0 ],
                                    "source": [ "obj-180", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 0 ],
                                    "midpoints": [ 370.6639246940613, 459.0, 396.0, 459.0, 396.0, 540.0, 392.0757238268852, 540.0 ],
                                    "source": [ "obj-29", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-38", 0 ],
                                    "midpoints": [ 349.6639246940613, 459.0, 336.0, 459.0, 336.0, 639.0, 360.2575448155403, 639.0 ],
                                    "source": [ "obj-29", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-41", 0 ],
                                    "midpoints": [ 360.1639246940613, 441.0, 360.2575448155403, 441.0 ],
                                    "source": [ "obj-29", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-48", 0 ],
                                    "source": [ "obj-30", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-50", 0 ],
                                    "midpoints": [ 458.6803150177002, 459.0, 444.0, 459.0, 444.0, 639.0, 468.59086859226227, 639.0 ],
                                    "source": [ "obj-30", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-53", 0 ],
                                    "midpoints": [ 479.6803150177002, 459.0, 504.0, 459.0, 504.0, 543.0, 500.4090476036072, 543.0 ],
                                    "source": [ "obj-30", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-55", 0 ],
                                    "source": [ "obj-31", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-57", 0 ],
                                    "midpoints": [ 566.8770332336426, 459.0, 555.0, 459.0, 555.0, 639.0, 577.6817680597305, 639.0 ],
                                    "source": [ "obj-31", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 0 ],
                                    "midpoints": [ 587.8770332336426, 459.0, 612.0, 459.0, 612.0, 552.0, 610.2575227618217, 552.0 ],
                                    "source": [ "obj-31", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-62", 0 ],
                                    "source": [ "obj-32", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-64", 0 ],
                                    "midpoints": [ 690.6475214958191, 459.0, 675.0, 459.0, 675.0, 639.0, 700.4090299606323, 639.0 ],
                                    "source": [ "obj-32", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-67", 0 ],
                                    "midpoints": [ 711.6475214958191, 459.0, 735.0, 459.0, 735.0, 552.0, 732.2272089719772, 552.0 ],
                                    "source": [ "obj-32", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-34", 0 ],
                                    "source": [ "obj-33", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 0 ],
                                    "source": [ "obj-34", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-38", 0 ],
                                    "order": 1,
                                    "source": [ "obj-36", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-45", 0 ],
                                    "midpoints": [ 392.83329951763153, 642.0, 444.0, 642.0, 444.0, 723.0, 789.3318862915039, 723.0 ],
                                    "order": 0,
                                    "source": [ "obj-36", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-83", 0 ],
                                    "source": [ "obj-37", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 0 ],
                                    "source": [ "obj-38", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-85", 0 ],
                                    "source": [ "obj-4", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-38", 0 ],
                                    "order": 1,
                                    "source": [ "obj-40", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-45", 0 ],
                                    "midpoints": [ 360.2575448155403, 615.0, 588.0, 615.0, 588.0, 639.0, 789.3318862915039, 639.0 ],
                                    "order": 0,
                                    "source": [ "obj-40", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-42", 0 ],
                                    "source": [ "obj-41", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-40", 0 ],
                                    "source": [ "obj-42", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-81", 0 ],
                                    "source": [ "obj-43", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-79", 0 ],
                                    "source": [ "obj-45", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-49", 0 ],
                                    "source": [ "obj-47", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-47", 0 ],
                                    "source": [ "obj-48", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "midpoints": [ 468.59086859226227, 615.0, 555.0, 615.0, 555.0, 687.0, 829.6680183410645, 687.0 ],
                                    "order": 0,
                                    "source": [ "obj-49", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-50", 0 ],
                                    "order": 1,
                                    "source": [ "obj-49", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-26", 0 ],
                                    "source": [ "obj-50", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "midpoints": [ 500.4090476036072, 642.0, 555.0, 642.0, 555.0, 687.0, 829.6680183410645, 687.0 ],
                                    "order": 0,
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-50", 0 ],
                                    "order": 1,
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "source": [ "obj-52", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-52", 0 ],
                                    "source": [ "obj-53", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-56", 0 ],
                                    "source": [ "obj-54", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-54", 0 ],
                                    "source": [ "obj-55", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "midpoints": [ 578.4393437504768, 639.0, 807.0, 639.0, 807.0, 750.0, 869.1638143062592, 750.0 ],
                                    "order": 0,
                                    "source": [ "obj-56", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-57", 0 ],
                                    "order": 1,
                                    "source": [ "obj-56", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-57", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "midpoints": [ 611.015098452568, 642.0, 675.0, 642.0, 675.0, 723.0, 807.0, 723.0, 807.0, 750.0, 869.1638143062592, 750.0 ],
                                    "order": 0,
                                    "source": [ "obj-58", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-57", 0 ],
                                    "order": 1,
                                    "source": [ "obj-58", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-58", 0 ],
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-59", 0 ],
                                    "source": [ "obj-60", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-63", 0 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "source": [ "obj-62", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "midpoints": [ 700.4090299606323, 639.0, 907.819274187088, 639.0 ],
                                    "order": 0,
                                    "source": [ "obj-63", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-64", 0 ],
                                    "order": 1,
                                    "source": [ "obj-63", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-28", 0 ],
                                    "source": [ "obj-64", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "midpoints": [ 732.9847846627235, 642.0, 907.819274187088, 642.0 ],
                                    "order": 0,
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-64", 0 ],
                                    "order": 1,
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "source": [ "obj-66", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-66", 0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-74", 0 ],
                                    "source": [ "obj-79", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-75", 0 ],
                                    "source": [ "obj-81", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-76", 0 ],
                                    "source": [ "obj-83", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-77", 0 ],
                                    "source": [ "obj-85", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-100", 0 ],
                                    "order": 0,
                                    "source": [ "obj-86", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-104", 0 ],
                                    "midpoints": [ 474.8720726768176, 330.0, 458.6803150177002, 330.0 ],
                                    "order": 0,
                                    "source": [ "obj-86", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-106", 0 ],
                                    "midpoints": [ 496.5387393434842, 330.0, 566.8770332336426, 330.0 ],
                                    "order": 0,
                                    "source": [ "obj-86", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-108", 0 ],
                                    "midpoints": [ 518.2054060101509, 330.0, 690.6475214958191, 330.0 ],
                                    "order": 0,
                                    "source": [ "obj-86", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-96", 0 ],
                                    "midpoints": [ 453.2054060101509, 330.0, 349.6639246940613, 330.0 ],
                                    "order": 1,
                                    "source": [ "obj-86", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-97", 0 ],
                                    "order": 1,
                                    "source": [ "obj-86", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-98", 0 ],
                                    "order": 1,
                                    "source": [ "obj-86", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-99", 0 ],
                                    "order": 1,
                                    "source": [ "obj-86", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-86", 0 ],
                                    "source": [ "obj-87", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-102", 0 ],
                                    "source": [ "obj-96", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 1347.2222864627838, 1958.3334267139435, 92.5, 22.0 ],
                    "text": "p livetriggers"
                }
            },
            {
                "box": {
                    "id": "obj-144",
                    "lastchannelcount": 0,
                    "maxclass": "live.gain~",
                    "numinlets": 2,
                    "numoutlets": 5,
                    "outlettype": [ "signal", "signal", "", "float", "list" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 1111.1111640930176, 2211.111216545105, 48.0, 136.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.gain~[1]",
                            "parameter_mmax": 6.0,
                            "parameter_mmin": -70.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "live.gain~",
                            "parameter_type": 0,
                            "parameter_unitstyle": 4
                        }
                    },
                    "varname": "live.gain~[1]"
                }
            },
            {
                "box": {
                    "id": "obj-145",
                    "maxclass": "ezdac~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 1111.1111640930176, 2363.889001607895, 45.0, 45.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-147",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
                    "patching_rect": [ 1111.1111640930176, 2050.0000977516174, 87.0, 22.0 ],
                    "text": "mc.selector~ 3"
                }
            },
            {
                "box": {
                    "fontsize": 12.0,
                    "id": "obj-148",
                    "maxclass": "live.tab",
                    "num_lines_patching": 4,
                    "num_lines_presentation": 0,
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "", "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 472.22224473953247, 1372.2222876548767, 121.73912811279297, 201.0870110988617 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_enum": [ "closed", "average", "mechanical", "ratio" ],
                            "parameter_longname": "live.tab[2]",
                            "parameter_mmax": 3,
                            "parameter_modmode": 0,
                            "parameter_shortname": "live.tab",
                            "parameter_type": 2,
                            "parameter_unitstyle": 9
                        }
                    },
                    "varname": "live.tab[2]"
                }
            },
            {
                "box": {
                    "id": "obj-149",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 3,
                    "outlettype": [ "multichannelsignal", "multichannelsignal", "multichannelsignal" ],
                    "patching_rect": [ 1102.77783036232, 1958.3334267139435, 126.0, 22.0 ],
                    "text": "mc.gate~ 3 @chans 4"
                }
            },
            {
                "box": {
                    "id": "obj-152",
                    "maxclass": "newobj",
                    "numinlets": 9,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "signal" ],
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
                        "rect": [ 34.0, 95.0, 1402.0, 762.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-111",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 1027.2770093083382, 981.818172454834, 40.0, 22.0 ],
                                    "text": "*~ 0.3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-112",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 963.9436740875244, 981.818172454834, 40.0, 22.0 ],
                                    "text": "*~ 0.7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-162",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 455.8669743537903, 981.818172454834, 40.0, 22.0 ],
                                    "text": "*~ 0.3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-161",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 392.52872908115387, 981.818172454834, 40.0, 22.0 ],
                                    "text": "*~ 0.7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-108",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1151.8085260391235, 817.4560726284981, 59.0, 22.0 ],
                                    "text": "1., 0. 120"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-109",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 1151.8085260391235, 846.4560726284981, 34.0, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-110",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 1140.8085260391235, 872.4560726284981, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-105",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 852.0, 817.4560726284981, 59.0, 22.0 ],
                                    "text": "1., 0. 120"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-106",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 852.0, 845.4560726284981, 34.0, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-107",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 842.0, 872.4560726284981, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-47",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 591.594245672226, 817.4560726284981, 59.0, 22.0 ],
                                    "text": "1., 0. 120"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 591.594245672226, 845.7746589779854, 34.0, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-104",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 580.9747757911682, 872.3233336806297, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-140",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 293.0385813117027, 817.6056445240974, 59.0, 22.0 ],
                                    "text": "1., 0. 120"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-141",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 293.0385813117027, 845.7746589779854, 34.0, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-142",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 282.47520089149475, 871.8309973478317, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 998.0033324956894, 1097.7272622585297, 74.0, 22.0 ],
                                    "text": "svf~ 500 0.3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 421.8669743537903, 1097.7272622585297, 74.0, 22.0 ],
                                    "text": "svf~ 500 0.3"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-198",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 1022.5352246761322, 338.0281734466553, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-197",
                                    "maxclass": "scope~",
                                    "numinlets": 2,
                                    "numoutlets": 0,
                                    "patching_rect": [ 821.975195646286, 1018.1818084716797, 95.0, 75.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-196",
                                    "maxclass": "scope~",
                                    "numinlets": 2,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1130.3085260391235, 1018.1818084716797, 95.0, 75.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-195",
                                    "maxclass": "scope~",
                                    "numinlets": 2,
                                    "numoutlets": 0,
                                    "patching_rect": [ 569.594245672226, 1018.1818084716797, 95.0, 75.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-194",
                                    "maxclass": "scope~",
                                    "numinlets": 2,
                                    "numoutlets": 0,
                                    "patching_rect": [ 260.0704391002655, 1018.1818084716797, 95.0, 75.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-193",
                                    "maxclass": "scope~",
                                    "numinlets": 2,
                                    "numoutlets": 0,
                                    "patching_rect": [ 835.5033340454102, 1296.5908967256546, 95.0, 75.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-192",
                                    "maxclass": "scope~",
                                    "numinlets": 2,
                                    "numoutlets": 0,
                                    "patching_rect": [ 670.7306083440781, 1296.5908967256546, 95.0, 75.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-189",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 540.8450775146484, 395.77465307712555, 42.0, 22.0 ],
                                    "text": "1. 100"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-190",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 587.3239513635635, 397.18310379981995, 42.0, 22.0 ],
                                    "text": "0. 300"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-191",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "int", "int" ],
                                    "patching_rect": [ 546.478880405426, 360.5633850097656, 68.0, 22.0 ],
                                    "text": "change 0.5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-186",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 633.8028252124786, 397.18310379981995, 42.0, 22.0 ],
                                    "text": "1. 100"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-187",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 680.2816990613937, 397.18310379981995, 42.0, 22.0 ],
                                    "text": "0. 300"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-188",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "int", "int" ],
                                    "patching_rect": [ 632.3943744897842, 360.5633850097656, 68.0, 22.0 ],
                                    "text": "change 0.5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-182",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 728.1690236330032, 397.18310379981995, 42.0, 22.0 ],
                                    "text": "1. 100"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-183",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 774.6478974819183, 397.18310379981995, 42.0, 22.0 ],
                                    "text": "0. 300"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-184",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "int", "int" ],
                                    "patching_rect": [ 714.0845164060593, 360.5633850097656, 68.0, 22.0 ],
                                    "text": "change 0.5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-185",
                                    "maxclass": "toggle",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 714.0845164060593, 329.5774691104889, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-179",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 446.47887909412384, 395.77465307712555, 42.0, 22.0 ],
                                    "text": "1. 100"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-180",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 492.95775294303894, 395.77465307712555, 42.0, 22.0 ],
                                    "text": "0. 300"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-181",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "int", "int" ],
                                    "patching_rect": [ 466.1971892118454, 360.5633850097656, 68.0, 22.0 ],
                                    "text": "change 0.5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-158",
                                    "maxclass": "toggle",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 632.3943744897842, 329.5774691104889, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-156",
                                    "maxclass": "toggle",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 546.478880405426, 329.5774691104889, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-154",
                                    "maxclass": "toggle",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 466.1971892118454, 329.5774691104889, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-134",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 271.8309894800186, 687.3239526748657, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-133",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 346.47887778282166, 623.9436701536179, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-132",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 1190.1408606767654, 725.3521221876144, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-131",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 866.1971944570541, 725.3521221876144, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-130",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 604.2253600358963, 725.3521221876144, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-129",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 338.0281734466553, 725.3521221876144, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-128",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 1130.9859303236008, 725.3521221876144, 34.0, 22.0 ],
                                    "text": "*~ 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-127",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 832.3943771123886, 725.3521221876144, 34.0, 22.0 ],
                                    "text": "*~ 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-126",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 570.4225426912308, 725.3521221876144, 34.0, 22.0 ],
                                    "text": "*~ 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-125",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 271.8309894800186, 725.3521221876144, 34.0, 22.0 ],
                                    "text": "*~ 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-124",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 670.7306083440781, 1243.1818063259125, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-123",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 845.730606675148, 1235.2272609472275, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-122",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 1197.3539799451828, 986.4090814590454, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-121",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 1169.0140998363495, 784.5070525407791, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-120",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 881.9436740875244, 986.318172454834, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-119",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 923.9436740875244, 777.4647989273071, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-118",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 654.9295860528946, 773.2394467592239, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-117",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 354.92958211898804, 777.4647989273071, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-116",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 606.4990072250366, 936.9047529697418, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-115",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 595.7847216129303, 961.9047527313232, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-114",
                                    "maxclass": "meter~",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 172.57043993473053, 986.3636269569397, 80.0, 13.0 ]
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-80",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 122.53521287441254, 529.5774717330933, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-81",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 122.53521287441254, 502.8169080018997, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-76",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 122.53521287441254, 478.87324571609497, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-78",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 122.53521287441254, 452.1126819849014, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-74",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 122.53521287441254, 426.7605689764023, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-72",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 122.53521287441254, 398.59155452251434, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-67",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 1163.380296945572, 692.9577555656433, 94.73683369159698, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-63",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 604.2253600358963, 692.9577555656433, 103.0075096487999, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-62",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 439.43662548065186, 688.7324033975601, 65.07936608791351, 20.0 ],
                                    "text": "envelope"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 866.1971944570541, 692.9577555656433, 116.54134303331375, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 338.0281734466553, 687.3239526748657, 93.233074426651, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-103",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 1130.3085260391235, 981.8636269569397, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-102",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 821.975195646286, 981.818172454834, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-101",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 569.594245672226, 981.818172454834, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 12.0,
                                    "id": "obj-100",
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 260.0704391002655, 981.818172454834, 56.0, 22.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-99",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 569.594245672226, 933.333324432373, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-98",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 260.0704391002655, 934.523800611496, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-97",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 1130.3085260391235, 935.7142767906189, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-96",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 821.975195646286, 936.9047529697418, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-94",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 791.1851526498795, 1201.1363521814346, 29.5, 22.0 ],
                                    "text": "+~"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-95",
                                    "index": 2,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 791.1851526498795, 1235.2272609472275, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-93",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 945.0704349279404, 459.1549355983734, 29.5, 22.0 ],
                                    "text": "+~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-92",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 907.0422654151917, 459.1549355983734, 29.5, 22.0 ],
                                    "text": "+~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-91",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 755.9578802585602, 1201.1363521814346, 29.5, 22.0 ],
                                    "text": "+~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-89",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 1064.788746356964, 300.00000393390656, 74.0, 22.0 ],
                                    "text": "svf~ 150 0.6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-90",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 1022.5352246761322, 267.6056373119354, 39.0, 22.0 ],
                                    "text": "click~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-87",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 907.0422654151917, 397.18310379981995, 81.0, 22.0 ],
                                    "text": "svf~ 3000 0.4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-88",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 908.450716137886, 267.6056373119354, 39.0, 22.0 ],
                                    "text": "click~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-85",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 1000.0000131130219, 369.014089345932, 81.0, 22.0 ],
                                    "text": "svf~ 3000 0.4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-86",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 984.5070551633835, 267.6056373119354, 39.0, 22.0 ],
                                    "text": "click~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-84",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 946.4788856506348, 300.00000393390656, 74.0, 22.0 ],
                                    "text": "svf~ 150 0.6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-83",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 946.4788856506348, 267.6056373119354, 39.0, 22.0 ],
                                    "text": "click~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-82",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 661.9718396663666, 108.45070564746857, 150.0, 20.0 ],
                                    "text": "heel = body, toe = crunch"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-79",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 1022.5352246761322, 238.0281721353531, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-77",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 984.5070551633835, 238.0281721353531, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-75",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 946.4788856506348, 238.0281721353531, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-73",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 908.450716137886, 238.0281721353531, 24.0, 24.0 ]
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
                                    "patching_rect": [ 640.8450788259506, 301.40845465660095, 50.0, 22.0 ]
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
                                    "patching_rect": [ 602.8169093132019, 277.4647923707962, 50.0, 22.0 ]
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
                                    "patching_rect": [ 564.7887398004532, 301.40845465660095, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-68",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 528.1690210103989, 277.4647923707962, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-66",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 523.9436688423157, 133.8028186559677, 427.42105650901794, 20.0 ],
                                    "text": "left foot toe, left foot heel, right foot toe, right foot heel"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 528.1690210103989, 212.67605912685394, 143.210520029068, 20.0 ],
                                    "text": "step toggles"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-64",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 909.8591668605804, 160.56338238716125, 143.210520029068, 33.0 ],
                                    "text": "bangs when a step is triggered"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-57",
                                    "index": 9,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 1022.5352246761322, 198.59155189990997, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-58",
                                    "index": 8,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 984.5070551633835, 198.59155189990997, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-59",
                                    "index": 7,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 946.4788856506348, 198.59155189990997, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-60",
                                    "index": 6,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 908.450716137886, 198.59155189990997, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-56",
                                    "index": 5,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 640.8450788259506, 245.07042574882507, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-55",
                                    "index": 4,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 602.8169093132019, 245.07042574882507, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-54",
                                    "index": 3,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 564.7887398004532, 245.07042574882507, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-53",
                                    "index": 2,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 528.1690210103989, 245.07042574882507, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 94.3661984205246, 185.9154953956604, 150.0, 20.0 ],
                                    "text": "synthengine subpatch"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 998.0033324956894, 1065.9090807437897, 29.5, 22.0 ],
                                    "text": "/~ 2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 998.0033324956894, 1038.6363537311554, 29.5, 22.0 ],
                                    "text": "+~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1168.4037637710571, 904.7618961334229, 109.56521379947662, 20.0 ],
                                    "text": "R crunch volume"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 1130.3085260391235, 902.380943775177, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 868.4037666320801, 903.5714199542999, 90.43477964401245, 20.0 ],
                                    "text": "R body volume"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 831.4990050792694, 902.380943775177, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-27",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1180.2817056179047, 550.7042325735092, 150.0, 33.0 ],
                                    "text": "1.2 is the exponential base"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-30",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1073.2394506931305, 584.5070499181747, 89.58729386329651, 20.0 ],
                                    "text": "crunch ranges"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-36",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 907.0422654151917, 583.0985991954803, 144.0, 22.0 ],
                                    "text": "scale~ 0. 1. 1500. 800. 3."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-39",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1054.9295912981033, 552.1126832962036, 77.77777898311615, 20.0 ],
                                    "text": "body ranges"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-40",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 907.0422654151917, 550.7042325735092, 137.0, 22.0 ],
                                    "text": "scale~ 0. 1. 200. 60. 1.2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-41",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1256.338044643402, 618.3098672628403, 74.13792979717255, 33.0 ],
                                    "text": "texture filter\n      (crunch)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 1095.7746622562408, 657.7464874982834, 81.0, 22.0 ],
                                    "text": "svf~ 2500 0.5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-44",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 1095.7746622562408, 629.5774730443954, 44.0, 22.0 ],
                                    "text": "noise~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-45",
                                    "maxclass": "panel",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 1073.2394506931305, 609.8591629266739, 263.6908589601517, 148.69608581066132 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-46",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 980.2817029953003, 618.3098672628403, 63.793102383613586, 20.0 ],
                                    "text": "body filter"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-48",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 832.3943771123886, 657.7464874982834, 85.0, 22.0 ],
                                    "text": "lores~ 120 0.7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-49",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 832.3943771123886, 629.5774730443954, 38.0, 22.0 ],
                                    "text": "pink~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-50",
                                    "maxclass": "panel",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 818.3098698854446, 609.8591629266739, 237.2276973426342, 148.275869846344 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-38",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 755.9578802585602, 1235.2272609472275, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-35",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 421.8669743537903, 1065.9090807437897, 29.5, 22.0 ],
                                    "text": "/~ 2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-34",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 421.8669743537903, 1038.6363537311554, 29.5, 22.0 ],
                                    "text": "+~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-32",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 607.6894834041595, 904.7618961334229, 109.56521379947662, 20.0 ],
                                    "text": "L crunch volume"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-33",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 569.594245672226, 902.380943775177, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-31",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 304.1180577278137, 902.380943775177, 90.43477964401245, 20.0 ],
                                    "text": "L body volume"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 271.97520089149475, 902.380943775177, 29.5, 22.0 ],
                                    "text": "*~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-28",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 619.7183179855347, 549.2957818508148, 150.0, 33.0 ],
                                    "text": "1.2 is the exponential base"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-25",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 514.0845137834549, 573.2394441366196, 89.58729386329651, 20.0 ],
                                    "text": "crunch ranges"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-26",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 346.47887778282166, 571.8309934139252, 144.0, 22.0 ],
                                    "text": "scale~ 0. 1. 1500. 800. 3."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 494.36620366573334, 540.8450775146484, 77.77777898311615, 20.0 ],
                                    "text": "body ranges"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 346.47887778282166, 536.6197253465652, 137.0, 22.0 ],
                                    "text": "scale~ 0. 1. 200. 60. 1.2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1214.8323347568512, 1386.9047486782074, 100.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 695.7746570110321, 618.3098672628403, 74.13792979717255, 33.0 ],
                                    "text": "texture filter\n      (crunch)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 628.169022321701, 653.5211353302002, 141.26984345912933, 20.0 ],
                                    "text": "1500Hz, Resonance 0.2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 529.5774717330933, 657.7464874982834, 81.0, 22.0 ],
                                    "text": "svf~ 2500 0.5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 529.5774717330933, 629.5774730443954, 44.0, 22.0 ],
                                    "text": "noise~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "panel",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 515.4929645061493, 609.8591629266739, 263.8793447613716, 148.275869846344 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 419.7183153629303, 618.3098672628403, 63.793102383613586, 20.0 ],
                                    "text": "body filter"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 370.4225400686264, 659.1549382209778, 133.90804374217987, 20.0 ],
                                    "text": "200Hz, Resonance 0.5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 271.8309894800186, 657.7464874982834, 85.0, 22.0 ],
                                    "text": "lores~ 120 0.7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 271.8309894800186, 629.5774730443954, 38.0, 22.0 ],
                                    "text": "pink~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 6,
                                    "outlettype": [ "signal", "signal", "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 281.6901445388794, 345.07042706012726, 84.0, 22.0 ],
                                    "text": "mc.unpack~ 6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 377.4647936820984, 491.54930222034454, 200.0, 33.0 ],
                                    "text": "L-body, L-crunch, R-body, R-crunch, (Heaviness L and R)"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-1",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "multichannelsignal" ],
                                    "patching_rect": [ 281.6901445388794, 202.81690406799316, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "panel",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 256.33803153038025, 609.8591629266739, 242.24139201641083, 144.82759380340576 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-195", 0 ],
                                    "source": [ "obj-101", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-197", 0 ],
                                    "source": [ "obj-102", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 1 ],
                                    "source": [ "obj-104", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-106", 0 ],
                                    "source": [ "obj-105", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-107", 1 ],
                                    "source": [ "obj-106", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-23", 1 ],
                                    "source": [ "obj-107", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-109", 0 ],
                                    "source": [ "obj-108", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-110", 1 ],
                                    "source": [ "obj-109", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 1 ],
                                    "source": [ "obj-110", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 1 ],
                                    "source": [ "obj-111", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "source": [ "obj-112", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-117", 0 ],
                                    "order": 0,
                                    "source": [ "obj-125", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-29", 0 ],
                                    "order": 1,
                                    "source": [ "obj-125", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-118", 0 ],
                                    "order": 0,
                                    "source": [ "obj-126", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 0 ],
                                    "order": 1,
                                    "source": [ "obj-126", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-119", 0 ],
                                    "order": 0,
                                    "source": [ "obj-127", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-23", 0 ],
                                    "order": 1,
                                    "source": [ "obj-127", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-121", 0 ],
                                    "order": 0,
                                    "source": [ "obj-128", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "order": 1,
                                    "source": [ "obj-128", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-97", 0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-141", 0 ],
                                    "source": [ "obj-140", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-142", 1 ],
                                    "source": [ "obj-141", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-29", 1 ],
                                    "source": [ "obj-142", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-181", 0 ],
                                    "source": [ "obj-154", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-191", 0 ],
                                    "source": [ "obj-156", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-188", 0 ],
                                    "source": [ "obj-158", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-34", 0 ],
                                    "source": [ "obj-161", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-34", 1 ],
                                    "source": [ "obj-162", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-126", 0 ],
                                    "source": [ "obj-17", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-63", 0 ],
                                    "midpoints": [ 455.97887909412384, 476.1397799253464, 604.2819118499756, 476.1397799253464, 604.2819118499756, 644.1397799253464, 613.7253600358963, 644.1397799253464 ],
                                    "source": [ "obj-179", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 0 ],
                                    "source": [ "obj-18", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-63", 0 ],
                                    "midpoints": [ 502.45775294303894, 476.1397799253464, 604.2819118499756, 476.1397799253464, 604.2819118499756, 644.1397799253464, 613.7253600358963, 644.1397799253464 ],
                                    "source": [ "obj-180", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-179", 0 ],
                                    "source": [ "obj-181", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-180", 0 ],
                                    "source": [ "obj-181", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "midpoints": [ 737.6690236330032, 542.1397799253464, 820.2819118499756, 542.1397799253464, 820.2819118499756, 695.1397799253464, 875.6971944570541, 695.1397799253464 ],
                                    "source": [ "obj-182", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "midpoints": [ 784.1478974819183, 440.1397799253464, 790.2819118499756, 440.1397799253464, 790.2819118499756, 596.1397799253464, 847.2819118499756, 596.1397799253464, 847.2819118499756, 593.1397799253464, 875.6971944570541, 593.1397799253464 ],
                                    "source": [ "obj-183", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-182", 0 ],
                                    "source": [ "obj-184", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-183", 0 ],
                                    "source": [ "obj-184", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-184", 0 ],
                                    "source": [ "obj-185", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-67", 0 ],
                                    "midpoints": [ 643.3028252124786, 536.1397799253464, 1165.2819118499756, 536.1397799253464, 1165.2819118499756, 596.1397799253464, 1172.880296945572, 596.1397799253464 ],
                                    "source": [ "obj-186", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-67", 0 ],
                                    "midpoints": [ 689.7816990613937, 536.1397799253464, 1165.2819118499756, 536.1397799253464, 1165.2819118499756, 596.1397799253464, 1172.880296945572, 596.1397799253464 ],
                                    "source": [ "obj-187", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-186", 0 ],
                                    "source": [ "obj-188", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-187", 0 ],
                                    "source": [ "obj-188", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 550.3450775146484, 476.1397799253464, 331.2819118499756, 476.1397799253464, 331.2819118499756, 653.1397799253464, 364.2819118499756, 653.1397799253464, 364.2819118499756, 680.1397799253464, 347.5281734466553, 680.1397799253464 ],
                                    "source": [ "obj-189", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 596.8239513635635, 476.1397799253464, 331.2819118499756, 476.1397799253464, 331.2819118499756, 653.1397799253464, 364.2819118499756, 653.1397799253464, 364.2819118499756, 680.1397799253464, 347.5281734466553, 680.1397799253464 ],
                                    "source": [ "obj-190", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-189", 0 ],
                                    "source": [ "obj-191", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-190", 0 ],
                                    "source": [ "obj-191", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-125", 1 ],
                                    "order": 1,
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-129", 0 ],
                                    "order": 0,
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-133", 0 ],
                                    "order": 0,
                                    "source": [ "obj-22", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-7", 1 ],
                                    "midpoints": [ 355.97887778282166, 564.7605173587799, 332.6337569215601, 564.7605173587799, 332.6337569215601, 654.7605173587799, 314.3309894800186, 654.7605173587799 ],
                                    "order": 1,
                                    "source": [ "obj-22", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-96", 1 ],
                                    "midpoints": [ 840.9990050792694, 926.5790962576866, 841.975195646286, 926.5790962576866 ],
                                    "source": [ "obj-23", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 1 ],
                                    "midpoints": [ 355.97887778282166, 603.7605173587799, 521.0129077093942, 603.7605173587799, 521.0129077093942, 654.7605173587799, 570.0774717330933, 654.7605173587799 ],
                                    "source": [ "obj-26", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-98", 1 ],
                                    "source": [ "obj-29", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-91", 0 ],
                                    "midpoints": [ 486.3669743537903, 1165.620882818359, 765.4578802585602, 1165.620882818359 ],
                                    "source": [ "obj-3", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-116", 0 ],
                                    "order": 0,
                                    "source": [ "obj-33", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-99", 0 ],
                                    "order": 1,
                                    "source": [ "obj-33", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-35", 0 ],
                                    "source": [ "obj-34", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-3", 0 ],
                                    "source": [ "obj-35", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 1 ],
                                    "midpoints": [ 916.5422654151917, 605.1397799253464, 1066.2819118499756, 605.1397799253464, 1066.2819118499756, 653.1397799253464, 1136.2746622562408, 653.1397799253464 ],
                                    "source": [ "obj-36", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-94", 1 ],
                                    "midpoints": [ 1062.5033324956894, 1167.624338096939, 810.5492016691715, 1167.624338096939, 810.5492016691715, 1196.4599525928497, 811.1851526498795, 1196.4599525928497 ],
                                    "source": [ "obj-37", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-48", 1 ],
                                    "midpoints": [ 916.5422654151917, 575.1397799253464, 880.2819118499756, 575.1397799253464, 880.2819118499756, 653.1397799253464, 874.8943771123886, 653.1397799253464 ],
                                    "source": [ "obj-40", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-128", 0 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "source": [ "obj-44", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "source": [ "obj-47", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-127", 0 ],
                                    "source": [ "obj-48", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-48", 0 ],
                                    "source": [ "obj-49", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-104", 0 ],
                                    "midpoints": [ 304.1901445388794, 602.1397799253464, 244.2819118499756, 602.1397799253464, 244.2819118499756, 770.1397799253464, 502.2819118499756, 770.1397799253464, 502.2819118499756, 791.1397799253464, 590.4747757911682, 791.1397799253464 ],
                                    "order": 0,
                                    "source": [ "obj-5", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-107", 0 ],
                                    "midpoints": [ 317.1901445388794, 475.9332157643512, 790.2819118499756, 475.9332157643512, 790.2819118499756, 675.1596865206957, 851.5, 675.1596865206957 ],
                                    "order": 0,
                                    "source": [ "obj-5", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-110", 0 ],
                                    "midpoints": [ 330.1901445388794, 477.0, 804.0, 477.0, 804.0, 804.0, 1137.0, 804.0, 1137.0, 867.0, 1150.3085260391235, 867.0 ],
                                    "order": 0,
                                    "source": [ "obj-5", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-142", 0 ],
                                    "midpoints": [ 291.1901445388794, 602.1397799253464, 244.2819118499756, 602.1397799253464, 244.2819118499756, 788.1397799253464, 291.97520089149475, 788.1397799253464 ],
                                    "order": 0,
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-22", 0 ],
                                    "midpoints": [ 343.1901445388794, 527.1397799253464, 355.97887778282166, 527.1397799253464 ],
                                    "order": 1,
                                    "source": [ "obj-5", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-26", 0 ],
                                    "midpoints": [ 343.1901445388794, 527.1397799253464, 334.2819118499756, 527.1397799253464, 334.2819118499756, 572.1397799253464, 355.97887778282166, 572.1397799253464 ],
                                    "order": 0,
                                    "source": [ "obj-5", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 0 ],
                                    "midpoints": [ 356.1901445388794, 476.1397799253464, 790.2819118499756, 476.1397799253464, 790.2819118499756, 578.1397799253464, 916.5422654151917, 578.1397799253464 ],
                                    "order": 0,
                                    "source": [ "obj-5", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-40", 0 ],
                                    "midpoints": [ 356.1901445388794, 476.1397799253464, 790.2819118499756, 476.1397799253464, 790.2819118499756, 536.1397799253464, 916.5422654151917, 536.1397799253464 ],
                                    "order": 1,
                                    "source": [ "obj-5", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-72", 0 ],
                                    "order": 1,
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-74", 0 ],
                                    "order": 1,
                                    "source": [ "obj-5", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-76", 0 ],
                                    "order": 1,
                                    "source": [ "obj-5", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-78", 0 ],
                                    "order": 1,
                                    "source": [ "obj-5", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-80", 0 ],
                                    "order": 2,
                                    "source": [ "obj-5", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-81", 0 ],
                                    "order": 2,
                                    "source": [ "obj-5", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-127", 1 ],
                                    "order": 1,
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-131", 0 ],
                                    "order": 0,
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-53", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-69", 0 ],
                                    "source": [ "obj-54", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-71", 0 ],
                                    "source": [ "obj-55", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-70", 0 ],
                                    "source": [ "obj-56", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-79", 0 ],
                                    "source": [ "obj-57", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-77", 0 ],
                                    "source": [ "obj-58", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-75", 0 ],
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-7", 0 ],
                                    "source": [ "obj-6", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-73", 0 ],
                                    "source": [ "obj-60", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-104", 1 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-126", 1 ],
                                    "order": 1,
                                    "source": [ "obj-63", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-130", 0 ],
                                    "order": 0,
                                    "source": [ "obj-63", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-128", 1 ],
                                    "order": 1,
                                    "source": [ "obj-67", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-132", 0 ],
                                    "order": 0,
                                    "source": [ "obj-67", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-154", 0 ],
                                    "midpoints": [ 537.6690210103989, 314.1397799253464, 475.6971892118454, 314.1397799253464 ],
                                    "order": 1,
                                    "source": [ "obj-68", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-99", 1 ],
                                    "midpoints": [ 537.6690210103989, 477.0, 588.0, 477.0, 588.0, 558.0, 573.0, 558.0, 573.0, 570.0, 510.0, 570.0, 510.0, 930.0, 589.594245672226, 930.0 ],
                                    "order": 0,
                                    "source": [ "obj-68", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-156", 0 ],
                                    "order": 0,
                                    "source": [ "obj-69", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-98", 0 ],
                                    "midpoints": [ 574.2887398004532, 326.1397799253464, 499.2819118499756, 326.1397799253464, 499.2819118499756, 314.1397799253464, 241.2819118499756, 314.1397799253464, 241.2819118499756, 851.1397799253464, 269.5704391002655, 851.1397799253464 ],
                                    "order": 1,
                                    "source": [ "obj-69", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-125", 0 ],
                                    "order": 0,
                                    "source": [ "obj-7", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-134", 0 ],
                                    "order": 1,
                                    "source": [ "obj-7", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-185", 0 ],
                                    "midpoints": [ 650.3450788259506, 326.49093770980835, 723.5845164060593, 326.49093770980835 ],
                                    "order": 1,
                                    "source": [ "obj-70", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-96", 0 ],
                                    "midpoints": [ 650.3450788259506, 326.1397799253464, 700.2819118499756, 326.1397799253464, 700.2819118499756, 314.1397799253464, 826.2819118499756, 314.1397799253464, 826.2819118499756, 596.1397799253464, 802.2819118499756, 596.1397799253464, 802.2819118499756, 854.1397799253464, 831.475195646286, 854.1397799253464 ],
                                    "order": 0,
                                    "source": [ "obj-70", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-158", 0 ],
                                    "midpoints": [ 612.3169093132019, 302.1397799253464, 637.2819118499756, 302.1397799253464, 637.2819118499756, 326.1397799253464, 641.8943744897842, 326.1397799253464 ],
                                    "order": 1,
                                    "source": [ "obj-71", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-97", 1 ],
                                    "midpoints": [ 612.3169093132019, 300.0, 615.0, 300.0, 615.0, 393.0, 630.0, 393.0, 630.0, 534.0, 804.0, 534.0, 804.0, 804.0, 1116.0, 804.0, 1116.0, 930.0, 1150.3085260391235, 930.0 ],
                                    "order": 0,
                                    "source": [ "obj-71", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-47", 0 ],
                                    "midpoints": [ 917.950716137886, 264.0, 828.0, 264.0, 828.0, 594.0, 789.0, 594.0, 789.0, 804.0, 601.094245672226, 804.0 ],
                                    "order": 1,
                                    "source": [ "obj-73", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-88", 0 ],
                                    "order": 0,
                                    "source": [ "obj-73", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-140", 0 ],
                                    "midpoints": [ 955.9788856506348, 264.0, 828.0, 264.0, 828.0, 594.0, 789.0, 594.0, 789.0, 804.0, 302.5385813117027, 804.0 ],
                                    "order": 1,
                                    "source": [ "obj-75", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-83", 0 ],
                                    "order": 0,
                                    "source": [ "obj-75", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-108", 0 ],
                                    "midpoints": [ 994.0070551633835, 264.0, 1275.0, 264.0, 1275.0, 537.0, 1347.0, 537.0, 1347.0, 771.0, 1155.0, 771.0, 1155.0, 810.0, 1161.3085260391235, 810.0 ],
                                    "order": 0,
                                    "source": [ "obj-77", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-86", 0 ],
                                    "order": 1,
                                    "source": [ "obj-77", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-105", 0 ],
                                    "midpoints": [ 1032.0352246761322, 264.0, 828.0, 264.0, 828.0, 594.0, 804.0, 594.0, 804.0, 804.0, 861.5, 804.0 ],
                                    "order": 1,
                                    "source": [ "obj-79", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-90", 0 ],
                                    "order": 0,
                                    "source": [ "obj-79", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "source": [ "obj-8", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-84", 0 ],
                                    "source": [ "obj-83", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-92", 1 ],
                                    "midpoints": [ 955.9788856506348, 378.87101352214813, 892.1924521582467, 378.87101352214813, 892.1924521582467, 431.19710907526314, 927.0422654151917, 431.19710907526314 ],
                                    "source": [ "obj-84", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-93", 0 ],
                                    "midpoints": [ 1009.5000131130219, 430.5637608319521, 954.5704349279404, 430.5637608319521 ],
                                    "source": [ "obj-85", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-85", 0 ],
                                    "midpoints": [ 994.0070551633835, 291.87101352214813, 931.1924521582467, 291.87101352214813, 931.1924521582467, 357.87101352214813, 1009.5000131130219, 357.87101352214813 ],
                                    "source": [ "obj-86", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-92", 0 ],
                                    "source": [ "obj-87", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-87", 0 ],
                                    "source": [ "obj-88", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-93", 1 ],
                                    "midpoints": [ 1074.288746356964, 362.0047529840376, 1091.4530451944365, 362.0047529840376, 1091.4530451944365, 401.7991565973498, 1047.5924342378776, 401.7991565973498, 1047.5924342378776, 454.17444927990437, 965.0704349279404, 454.17444927990437 ],
                                    "source": [ "obj-89", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-198", 0 ],
                                    "order": 1,
                                    "source": [ "obj-90", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-89", 0 ],
                                    "order": 0,
                                    "source": [ "obj-90", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-124", 0 ],
                                    "order": 2,
                                    "source": [ "obj-91", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-192", 0 ],
                                    "order": 1,
                                    "source": [ "obj-91", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-38", 0 ],
                                    "order": 0,
                                    "source": [ "obj-91", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-91", 1 ],
                                    "midpoints": [ 916.5422654151917, 503.1397799253464, 775.2819118499756, 503.1397799253464, 775.2819118499756, 764.5745171289891, 775.9578802585602, 764.5745171289891 ],
                                    "source": [ "obj-92", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-94", 0 ],
                                    "midpoints": [ 954.5704349279404, 503.1397799253464, 800.6851526498795, 503.1397799253464 ],
                                    "source": [ "obj-93", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-123", 0 ],
                                    "order": 0,
                                    "source": [ "obj-94", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-193", 0 ],
                                    "order": 1,
                                    "source": [ "obj-94", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-95", 0 ],
                                    "order": 2,
                                    "source": [ "obj-94", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-102", 0 ],
                                    "order": 2,
                                    "source": [ "obj-96", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-112", 0 ],
                                    "midpoints": [ 831.475195646286, 971.5790962576866, 973.4436740875244, 971.5790962576866 ],
                                    "order": 0,
                                    "source": [ "obj-96", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-120", 0 ],
                                    "order": 1,
                                    "source": [ "obj-96", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-103", 0 ],
                                    "order": 2,
                                    "source": [ "obj-97", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-111", 0 ],
                                    "midpoints": [ 1139.8085260391235, 971.5790962576866, 1036.7770093083382, 971.5790962576866 ],
                                    "order": 3,
                                    "source": [ "obj-97", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-122", 0 ],
                                    "order": 0,
                                    "source": [ "obj-97", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-196", 0 ],
                                    "order": 1,
                                    "source": [ "obj-97", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-100", 0 ],
                                    "order": 2,
                                    "source": [ "obj-98", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-114", 0 ],
                                    "order": 3,
                                    "source": [ "obj-98", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-161", 0 ],
                                    "midpoints": [ 269.5704391002655, 968.3691778846551, 402.02872908115387, 968.3691778846551 ],
                                    "order": 0,
                                    "source": [ "obj-98", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-194", 0 ],
                                    "order": 1,
                                    "source": [ "obj-98", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-101", 0 ],
                                    "order": 1,
                                    "source": [ "obj-99", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-115", 0 ],
                                    "order": 0,
                                    "source": [ "obj-99", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-162", 0 ],
                                    "midpoints": [ 579.094245672226, 969.6174794741673, 465.3669743537903, 969.6174794741673 ],
                                    "order": 2,
                                    "source": [ "obj-99", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 1111.1111640930176, 2105.5556559562683, 269.79165637493134, 22.0 ],
                    "text": "p synthengine"
                }
            },
            {
                "box": {
                    "id": "obj-153",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
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
                        "rect": [ 81.0, 131.0, 1000.0, 692.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 619.6629708409309, 187.39327323436737, 33.146070063114166, 20.0 ],
                                    "text": "heel"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 475.84273463487625, 343.8202521800995, 31.0, 22.0 ],
                                    "text": "sig~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-30",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 475.84273463487625, 317.41575568914413, 103.0, 22.0 ],
                                    "text": "scale 20 200 0. 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-31",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 475.84273463487625, 254.4944023489952, 67.0, 22.0 ],
                                    "text": "clip 20 200"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-32",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 590.4494853615761, 185.39327323436737, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-33",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 492.6966685652733, 185.39327323436737, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-34",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "" ],
                                    "patching_rect": [ 475.84273463487625, 225.28091686964035, 35.0, 22.0 ],
                                    "text": "timer"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-35",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 590.4494853615761, 152.2472031712532, 96.0, 22.0 ],
                                    "text": "thresh~ 0.1 0.05"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-36",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 492.6966685652733, 152.2472031712532, 96.0, 22.0 ],
                                    "text": "thresh~ 0.1 0.05"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-28",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 167.01029992103577, 356.18554705381393, 31.0, 22.0 ],
                                    "text": "sig~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-26",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 281.5051443576813, 330.89688873291016, 150.0, 20.0 ],
                                    "text": "0. is slow, 1. is fast"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-24",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 167.01029992103577, 329.89688873291016, 103.0, 22.0 ],
                                    "text": "scale 20 200 0. 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-23",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 264.4329748749733, 292.2680248618126, 218.0, 33.0 ],
                                    "text": "20ms is speed walking, 150ms is more heavy or deliberate."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-22",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 242.78349155187607, 268.5566859841347, 217.01030552387238, 20.0 ],
                                    "text": "limits to range of walking (20 - 200 ms)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-20",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 167.01029992103577, 267.01029431819916, 67.0, 22.0 ],
                                    "text": "clip 20 200"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 309.5505865216255, 199.99998879432678, 34.83146345615387, 20.0 ],
                                    "text": "heel"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 281.5051443576813, 197.9381332397461, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 183.50514435768127, 197.9381332397461, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "" ],
                                    "patching_rect": [ 167.01029992103577, 237.62885266542435, 35.0, 22.0 ],
                                    "text": "timer"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 281.5051443576813, 164.94844436645508, 96.0, 22.0 ],
                                    "text": "thresh~ 0.1 0.05"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 183.50514435768127, 164.94844436645508, 96.0, 22.0 ],
                                    "text": "thresh~ 0.1 0.05"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 110.30927217006683, 194.84534990787506, 40.0, 22.0 ],
                                    "text": "*~ 0.5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 67.03436668713888, 194.84534990787506, 40.0, 22.0 ],
                                    "text": "*~ 0.5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 110.33333333333334, 164.94844436645508, 29.5, 22.0 ],
                                    "text": "+~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 67.03436668713888, 164.94844436645508, 29.5, 22.0 ],
                                    "text": "+~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [ "multichannelsignal" ],
                                    "patching_rect": [ 66.78436668713888, 427.3195636868477, 71.5, 22.0 ],
                                    "text": "mc.pack~ 6"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-14",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 66.78436668713888, 461.34018033742905, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 161.85566103458405, 107.18556106090546, 200.8064530491829, 20.0 ],
                                    "text": "left toe, left heel, right toe, right heel"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 67.0, 106.18556106090546, 84.0, 22.0 ],
                                    "text": "mc.unpack~ 4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1675.0, 1588.0, 100.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-1",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "multichannelsignal" ],
                                    "patching_rect": [ 67.0, 63.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-3", 0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 0 ],
                                    "source": [ "obj-10", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-20", 0 ],
                                    "source": [ "obj-11", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-11", 1 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-11", 0 ],
                                    "midpoints": [ 291.0051443576813, 228.71214625099674, 176.51029992103577, 228.71214625099674 ],
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 0 ],
                                    "source": [ "obj-19", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-24", 0 ],
                                    "source": [ "obj-20", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-28", 0 ],
                                    "source": [ "obj-24", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 4 ],
                                    "midpoints": [ 176.51029992103577, 414.0, 118.28436668713888, 414.0 ],
                                    "source": [ "obj-28", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 5 ],
                                    "midpoints": [ 485.34273463487625, 414.0, 128.78436668713888, 414.0 ],
                                    "source": [ "obj-29", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-10", 0 ],
                                    "midpoints": [ 98.16666666666667, 150.0, 291.0051443576813, 150.0 ],
                                    "order": 0,
                                    "source": [ "obj-3", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-35", 0 ],
                                    "midpoints": [ 141.5, 138.0, 599.9494853615761, 138.0 ],
                                    "order": 0,
                                    "source": [ "obj-3", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 0 ],
                                    "midpoints": [ 119.83333333333334, 138.0, 502.1966685652733, 138.0 ],
                                    "order": 0,
                                    "source": [ "obj-3", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 1 ],
                                    "midpoints": [ 98.16666666666667, 150.0, 87.03436668713888, 150.0 ],
                                    "order": 1,
                                    "source": [ "obj-3", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "order": 1,
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 1 ],
                                    "midpoints": [ 141.5, 150.0, 130.33333333333334, 150.0 ],
                                    "order": 1,
                                    "source": [ "obj-3", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "order": 1,
                                    "source": [ "obj-3", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-9", 0 ],
                                    "midpoints": [ 76.5, 150.0, 193.00514435768127, 150.0 ],
                                    "order": 0,
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-29", 0 ],
                                    "source": [ "obj-30", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-30", 0 ],
                                    "source": [ "obj-31", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-34", 0 ],
                                    "midpoints": [ 599.9494853615761, 216.01090505579486, 485.34273463487625, 216.01090505579486 ],
                                    "source": [ "obj-32", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-34", 1 ],
                                    "source": [ "obj-33", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-31", 0 ],
                                    "source": [ "obj-34", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-32", 0 ],
                                    "source": [ "obj-35", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 0 ],
                                    "source": [ "obj-36", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-6", 0 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 1 ],
                                    "order": 0,
                                    "source": [ "obj-6", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 0 ],
                                    "order": 1,
                                    "source": [ "obj-6", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 3 ],
                                    "order": 0,
                                    "source": [ "obj-8", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 2 ],
                                    "order": 1,
                                    "source": [ "obj-8", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-9", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 1258.3333933353424, 1997.222317457199, 55.0, 22.0 ],
                    "text": "p c_ratio"
                }
            },
            {
                "box": {
                    "id": "obj-154",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
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
                        "rect": [ 134.0, 164.0, 1000.0, 692.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 300.8925424218178, 125.48759657144547, 58.0, 22.0 ],
                                    "text": "loadbang"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-2",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 300.8925424218178, 159.50412338972092, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-19",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 206.61155879497528, 231.40494585037231, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-18",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "multichannelsignal" ],
                                    "patching_rect": [ 206.61155879497528, 121.48759657144547, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 206.61155879497528, 159.50412338972092, 84.0, 22.0 ],
                                    "text": "mc.unpack~ 4"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [ "multichannelsignal" ],
                                    "patching_rect": [ 207.0, 197.0, 126.0, 22.0 ],
                                    "text": "mc.pack~ 6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-15",
                                    "linecount": 4,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 276.033042550087, 275.2065963149071, 200.0, 60.0 ],
                                    "text": "Body is heel, more of the body sound\nCrunch is toe, more of that initial contact sound."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 276.033042550087, 249.58676302433014, 200.0, 20.0 ],
                                    "text": "L-body, L-crunch, R-body, R-crunch"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "linecount": 3,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 364.9999869465828, 165.4545395374298, 150.0, 47.0 ],
                                    "text": "might need processing later, but otherwise doesn't"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 206.61155879497528, 98.18181467056274, 200.8064530491829, 20.0 ],
                                    "text": "left toe, left heel, right toe, right heel"
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 0 ],
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 2 ],
                                    "source": [ "obj-17", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 3 ],
                                    "source": [ "obj-17", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 0 ],
                                    "source": [ "obj-17", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 1 ],
                                    "source": [ "obj-17", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 0 ],
                                    "source": [ "obj-18", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 5 ],
                                    "order": 0,
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 4 ],
                                    "order": 1,
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-3", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 1155.5556106567383, 1997.222317457199, 92.0, 22.0 ],
                    "text": "p c_mechanical"
                }
            },
            {
                "box": {
                    "id": "obj-155",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
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
                        "rect": [ 124.0, 141.0, 619.0, 692.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-27",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "setvalue", "int" ],
                                    "patching_rect": [ 502.43, 365.52, 54.0, 22.0 ],
                                    "text": "mc.input"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-26",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "setvalue", "int" ],
                                    "patching_rect": [ 506.4, 306.79, 59.0, 22.0 ],
                                    "text": "mc.target"
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-22",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 120.00000536441803, 213.14286667108536, 59.0, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-21",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 120.00000536441803, 241.44643937051296, 59.0, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-20",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 120.00000536441803, 269.75001206994057, 59.0, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-18",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 120.00000536441803, 298.0535847693682, 59.0, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-17",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 120.00000536441803, 355.42858731746674, 59.0, 23.0 ],
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
                                    "patching_rect": [ 120.00000536441803, 326.3571574687958, 59.0, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 335.8571286201477, 210.4838724732399, 58.0, 22.0 ],
                                    "text": "loadbang"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-12",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 335.8571286201477, 239.0553007721901, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [ "multichannelsignal" ],
                                    "patching_rect": [ 203.42858052253723, 326.8571574687958, 184.5356851220131, 22.0 ],
                                    "text": "mc.pack~ 6"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "signal", "signal", "signal", "signal" ],
                                    "patching_rect": [ 204.83871114253998, 159.6774204969406, 84.0, 22.0 ],
                                    "text": "mc.unpack~ 4"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-14",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 202.8571519255638, 360.5714446902275, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 269.64285457134247, 239.0553007721901, 40.0, 22.0 ],
                                    "text": "*~ 0.5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 203.22580790519714, 238.7096791267395, 40.0, 22.0 ],
                                    "text": "*~ 0.5"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 269.64285457134247, 210.4838724732399, 29.5, 22.0 ],
                                    "text": "+~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 203.22580790519714, 210.4838724732399, 29.5, 22.0 ],
                                    "text": "+~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 300.80645376443863, 161.29032373428345, 200.8064530491829, 20.0 ],
                                    "text": "left toe, left heel, right toe, right heel"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 1039.71633374691, 1156.7376127839088, 100.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-1",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "multichannelsignal" ],
                                    "patching_rect": [ 204.83871114253998, 85.22727191448212, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 1 ],
                                    "order": 0,
                                    "source": [ "obj-10", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 0 ],
                                    "order": 1,
                                    "source": [ "obj-10", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-3", 0 ],
                                    "midpoints": [ 212.72580790519714, 273.32812327123247, 189.0, 273.32812327123247, 189.0, 321.0, 129.50000536441803, 321.0 ],
                                    "order": 2,
                                    "source": [ "obj-10", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 0 ],
                                    "midpoints": [ 279.14285457134247, 312.0, 189.0, 312.0, 189.0, 351.0, 129.50000536441803, 351.0 ],
                                    "order": 2,
                                    "source": [ "obj-11", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 3 ],
                                    "order": 0,
                                    "source": [ "obj-11", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 2 ],
                                    "order": 1,
                                    "source": [ "obj-11", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 5 ],
                                    "order": 0,
                                    "source": [ "obj-12", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 4 ],
                                    "order": 1,
                                    "source": [ "obj-12", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-12", 0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-18", 0 ],
                                    "midpoints": [ 279.33871114254, 195.0, 189.0, 195.0, 189.0, 294.0, 129.50000536441803, 294.0 ],
                                    "order": 1,
                                    "source": [ "obj-16", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-20", 0 ],
                                    "midpoints": [ 257.67204447587335, 195.0, 189.0, 195.0, 189.0, 264.0, 129.50000536441803, 264.0 ],
                                    "order": 1,
                                    "source": [ "obj-16", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-21", 0 ],
                                    "midpoints": [ 236.00537780920664, 195.0, 189.0, 195.0, 189.0, 237.0, 129.50000536441803, 237.0 ],
                                    "order": 1,
                                    "source": [ "obj-16", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-22", 0 ],
                                    "midpoints": [ 214.33871114253998, 195.0, 129.50000536441803, 195.0 ],
                                    "order": 1,
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 1 ],
                                    "order": 0,
                                    "source": [ "obj-16", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "order": 0,
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-9", 1 ],
                                    "order": 0,
                                    "source": [ "obj-16", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-9", 0 ],
                                    "order": 0,
                                    "source": [ "obj-16", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 0 ],
                                    "source": [ "obj-19", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-10", 0 ],
                                    "source": [ "obj-8", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-11", 0 ],
                                    "source": [ "obj-9", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 1041.666716337204, 1997.222317457199, 75.0, 22.0 ],
                    "text": "p c_average"
                }
            },
            {
                "box": {
                    "id": "obj-156",
                    "maxclass": "newobj",
                    "numinlets": 5,
                    "numoutlets": 1,
                    "outlettype": [ "multichannelsignal" ],
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
                        "rect": [ 134.0, 95.0, 992.0, 762.0 ],
                        "visible": 1,
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-86",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 238.93807232379913, 348.1666536331177, 150.0, 20.0 ],
                                    "text": "Signalconditioning"
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-83",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 342.7354060411453, 938.7404940128326, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-82",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 815.2607164382935, 572.1518912315369, 82.0, 22.0 ],
                                    "text": "onepole~ 300"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-81",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 674.754389166832, 572.1518912315369, 82.0, 22.0 ],
                                    "text": "onepole~ 300"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-80",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 545.6404668092728, 572.1518912315369, 82.0, 22.0 ],
                                    "text": "onepole~ 300"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-79",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 614.9795963764191, 515.6249803304672, 34.0, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-78",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 559.7712651491165, 515.6249803304672, 34.0, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-77",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 504.56293392181396, 515.6249803304672, 34.0, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-76",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 387.89627170562744, 440.6249831914902, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-71",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 387.89627170562744, 382.2916520833969, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-70",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "bang" ],
                                    "patching_rect": [ 449.3546026945114, 515.6249803304672, 34.0, 22.0 ],
                                    "text": "line~"
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-69",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 338.93793773651123, 764.7058367729187, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-68",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 449.06451857089996, 697.468345284462, 82.0, 22.0 ],
                                    "text": "onepole~ 300"
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-67",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 579.4442636966705, 730.3797372579575, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-66",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 683.2417306900024, 730.3797372579575, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-65",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 825.0138807296753, 730.3797372579575, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-64",
                                    "maxclass": "scope~",
                                    "numinlets": 2,
                                    "numoutlets": 0,
                                    "patching_rect": [ 173.11515510082245, 749.3670787811279, 130.0, 130.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-50",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 803.4948936700821, 696.2025225162506, 64.0, 22.0 ],
                                    "text": "pow~ 1.93"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 803.4948936700821, 665.8227760791779, 122.0, 22.0 ],
                                    "text": "rampsmooth~ 10 120"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 803.4948936700821, 639.2404979467392, 60.0, 22.0 ],
                                    "text": "clip~ 0. 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-53",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 804.7607164382935, 607.5949287414551, 29.5, 22.0 ],
                                    "text": "-~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-45",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 664.254389166832, 696.2025225162506, 64.0, 22.0 ],
                                    "text": "pow~ 1.93"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-46",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 664.254389166832, 665.8227760791779, 122.0, 22.0 ],
                                    "text": "rampsmooth~ 10 120"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-47",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 664.254389166832, 639.2404979467392, 60.0, 22.0 ],
                                    "text": "clip~ 0. 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-48",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 664.254389166832, 607.5949287414551, 29.5, 22.0 ],
                                    "text": "-~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 533.8746440410614, 696.2025225162506, 64.0, 22.0 ],
                                    "text": "pow~ 1.93"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 533.8746440410614, 665.8227760791779, 122.0, 22.0 ],
                                    "text": "rampsmooth~ 10 120"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-44",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 533.8746440410614, 639.2404979467392, 60.0, 22.0 ],
                                    "text": "clip~ 0. 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-41",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 535.1404668092728, 607.5949287414551, 29.5, 22.0 ],
                                    "text": "-~"
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-14",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 338.93793773651123, 802.5316350460052, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-11",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 342.7354060411453, 902.5316337347031, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-12",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 342.7354060411453, 869.6202417612076, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-28",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 474.38097393512726, 806.3291033506393, 234.92063856124878, 20.0 ],
                                    "text": "making it high pass, onepole~ is low pass"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 507.29236590862274, 837.9746725559235, 154.3859634399414, 20.0 ],
                                    "text": "limiting values out of range"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-32",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 588.3050230741501, 865.8227734565735, 109.64912176132202, 20.0 ],
                                    "text": "envelope decaying"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-33",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 513.6214797496796, 888.607583284378, 116.66666555404663, 33.0 ],
                                    "text": "Ramped Loudness\nKantan, 2024 (1.93)"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-34",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 438.93793642520905, 894.9366971254349, 64.0, 22.0 ],
                                    "text": "pow~ 1.93"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-35",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 438.93793642520905, 864.5569506883621, 122.0, 22.0 ],
                                    "text": "rampsmooth~ 10 120"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-36",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 438.93793642520905, 836.7088497877121, 60.0, 22.0 ],
                                    "text": "clip~ 0. 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-38",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 438.93793642520905, 777.215179681778, 29.5, 22.0 ],
                                    "text": "-~"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 0,
                                    "patching_rect": [ 942.6470408439636, 188.9705846309662, 57.0, 22.0 ],
                                    "text": "condition"
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-22",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 846.2295875549316, 448.95831620693207, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-21",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 769.1462571620941, 449.9999828338623, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-20",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 691.0212601423264, 449.9999828338623, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "fontface": 0,
                                    "fontname": "Arial",
                                    "fontsize": 13.0,
                                    "id": "obj-19",
                                    "interval": 250.0,
                                    "maxclass": "number~",
                                    "mode": 2,
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "signal", "float" ],
                                    "patching_rect": [ 614.9795963764191, 449.9999828338623, 73.6842098236084, 23.0 ],
                                    "sig": 0.0
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 4,
                                    "numoutlets": 1,
                                    "outlettype": [ "multichannelsignal" ],
                                    "patching_rect": [ 732.6088186502457, 939.2404940128326, 90.0, 22.0 ],
                                    "text": "mc.combine~ 4"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-6",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 732.6088186502457, 975.9493542909622, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "ezdac~",
                                    "numinlets": 2,
                                    "numoutlets": 0,
                                    "patching_rect": [ 606.6462633609772, 353.1249865293503, 45.0, 45.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 2308.5714836120605, 3071.428644657135, 150.0, 20.0 ],
                                    "text": "blah"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 438.93793642520905, 341.6666536331177, 155.58064150810242, 33.0 ],
                                    "text": "time delay, left toe, left heel, right toe, right heel"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-4",
                                    "index": 5,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 561.854598402977, 382.2916520833969, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-3",
                                    "index": 4,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 521.2295999526978, 382.2916520833969, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-2",
                                    "index": 3,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 479.5629348754883, 382.2916520833969, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-1",
                                    "index": 2,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "signal" ],
                                    "patching_rect": [ 438.93793642520905, 382.2916520833969, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 0 ],
                                    "midpoints": [ 448.43793642520905, 435.5986683368683, 624.4795963764191, 435.5986683368683 ],
                                    "order": 0,
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-38", 0 ],
                                    "order": 2,
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-70", 0 ],
                                    "order": 1,
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-6", 0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-20", 0 ],
                                    "midpoints": [ 489.0629348754883, 435.5986683368683, 700.5212601423264, 435.5986683368683 ],
                                    "order": 0,
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-41", 0 ],
                                    "midpoints": [ 489.0629348754883, 603.0, 544.6404668092728, 603.0 ],
                                    "order": 1,
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-77", 0 ],
                                    "order": 2,
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-21", 0 ],
                                    "midpoints": [ 530.7295999526978, 435.5986683368683, 778.6462571620941, 435.5986683368683 ],
                                    "order": 0,
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-48", 0 ],
                                    "midpoints": [ 530.7295999526978, 501.0, 660.0, 501.0, 660.0, 600.0, 673.754389166832, 600.0 ],
                                    "order": 1,
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-78", 0 ],
                                    "order": 2,
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "midpoints": [ 448.43793642520905, 929.8616894911975, 742.1088186502457, 929.8616894911975 ],
                                    "order": 0,
                                    "source": [ "obj-34", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-83", 0 ],
                                    "order": 1,
                                    "source": [ "obj-34", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-11", 0 ],
                                    "order": 1,
                                    "source": [ "obj-35", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-34", 0 ],
                                    "order": 0,
                                    "source": [ "obj-35", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-12", 0 ],
                                    "order": 1,
                                    "source": [ "obj-36", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-35", 0 ],
                                    "order": 0,
                                    "source": [ "obj-36", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 0 ],
                                    "order": 1,
                                    "source": [ "obj-38", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 0 ],
                                    "order": 0,
                                    "source": [ "obj-38", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-22", 0 ],
                                    "midpoints": [ 571.354598402977, 435.5986683368683, 855.7295875549316, 435.5986683368683 ],
                                    "order": 0,
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-53", 0 ],
                                    "midpoints": [ 571.354598402977, 501.0, 801.0, 501.0, 801.0, 600.0, 814.2607164382935, 600.0 ],
                                    "order": 1,
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-79", 0 ],
                                    "order": 2,
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-44", 0 ],
                                    "source": [ "obj-41", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 1 ],
                                    "midpoints": [ 543.3746440410614, 717.181310415268, 570.6226079463959, 717.181310415268, 570.6226079463959, 792.181310415268, 765.7754853169123, 792.181310415268 ],
                                    "order": 0,
                                    "source": [ "obj-42", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-67", 0 ],
                                    "order": 1,
                                    "source": [ "obj-42", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-42", 0 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "source": [ "obj-44", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 2 ],
                                    "midpoints": [ 673.754389166832, 792.181310415268, 789.442151983579, 792.181310415268 ],
                                    "order": 0,
                                    "source": [ "obj-45", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-66", 0 ],
                                    "order": 1,
                                    "source": [ "obj-45", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-45", 0 ],
                                    "source": [ "obj-46", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-46", 0 ],
                                    "source": [ "obj-47", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-47", 0 ],
                                    "source": [ "obj-48", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 3 ],
                                    "order": 1,
                                    "source": [ "obj-50", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "order": 0,
                                    "source": [ "obj-50", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-50", 0 ],
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "source": [ "obj-52", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-52", 0 ],
                                    "source": [ "obj-53", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-38", 1 ],
                                    "order": 0,
                                    "source": [ "obj-68", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-64", 0 ],
                                    "order": 2,
                                    "source": [ "obj-68", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-69", 0 ],
                                    "order": 1,
                                    "source": [ "obj-68", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-70", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-76", 0 ],
                                    "source": [ "obj-71", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-70", 1 ],
                                    "midpoints": [ 397.39627170562744, 501.5986683368683, 473.8546026945114, 501.5986683368683 ],
                                    "order": 3,
                                    "source": [ "obj-76", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-77", 1 ],
                                    "midpoints": [ 397.39627170562744, 501.5986683368683, 529.062933921814, 501.5986683368683 ],
                                    "order": 2,
                                    "source": [ "obj-76", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-78", 1 ],
                                    "midpoints": [ 397.39627170562744, 501.5986683368683, 584.2712651491165, 501.5986683368683 ],
                                    "order": 1,
                                    "source": [ "obj-76", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-79", 1 ],
                                    "midpoints": [ 397.39627170562744, 501.5986683368683, 639.4795963764191, 501.5986683368683 ],
                                    "order": 0,
                                    "source": [ "obj-76", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-80", 0 ],
                                    "midpoints": [ 514.062933921814, 558.0, 555.1404668092728, 558.0 ],
                                    "source": [ "obj-77", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-81", 0 ],
                                    "midpoints": [ 569.2712651491165, 558.0, 684.254389166832, 558.0 ],
                                    "source": [ "obj-78", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-82", 0 ],
                                    "midpoints": [ 624.4795963764191, 558.0, 824.7607164382935, 558.0 ],
                                    "source": [ "obj-79", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-41", 1 ],
                                    "source": [ "obj-80", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-48", 1 ],
                                    "source": [ "obj-81", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-53", 1 ],
                                    "source": [ "obj-82", 0 ]
                                }
                            }
                        ],
                        "boxgroups": [
                            {
                                "boxes": [ "obj-3", "obj-4", "obj-1", "obj-2", "obj-7" ]
                            }
                        ]
                    },
                    "patching_rect": [ 1211.1111688613892, 1877.7778673171997, 132.0, 22.0 ],
                    "text": "p livesignalconditioning"
                }
            },
            {
                "box": {
                    "id": "obj-157",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "signal", "signal", "signal", "signal" ],
                    "patching_rect": [ 1225.0000584125519, 1836.1111986637115, 76.0, 22.0 ],
                    "text": "datainputlive"
                }
            },
            {
                "box": {
                    "id": "obj-467",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 1886.1112010478973, 2272.222330570221, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-466",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1886.1112010478973, 2302.777887582779, 29.5, 22.0 ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-464",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1858.333421945572, 2341.6667783260345, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-462",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1686.9564895629883, 408.6956443786621, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-460",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1843.4782257080078, 404.3478183746338, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-458",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2088.888988494873, 1272.2222828865051, 150.0, 33.0 ],
                    "text": "saving trigger values from calibration phase"
                }
            },
            {
                "box": {
                    "id": "obj-384",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1400.0000667572021, 1777.7778625488281, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-394",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2169.444547891617, 1850.0000882148743, 91.27484345436096, 20.0 ],
                    "text": "Saving the file!"
                }
            },
            {
                "box": {
                    "id": "obj-396",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2058.333431482315, 1588.8889646530151, 96.0, 20.0 ],
                    "text": "TOE AND HEEL"
                }
            },
            {
                "box": {
                    "id": "obj-397",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1708.3334147930145, 1594.4445204734802, 40.66666787862778, 20.0 ],
                    "text": "HEEL"
                }
            },
            {
                "box": {
                    "id": "obj-401",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1858.333421945572, 2236.111217737198, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-402",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1641.6667449474335, 1986.111205816269, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-403",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1808.333419561386, 1950.0000929832458, 31.0, 22.0 ],
                    "text": "time"
                }
            },
            {
                "box": {
                    "id": "obj-404",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "list", "list", "int" ],
                    "patching_rect": [ 1808.333419561386, 1972.2223162651062, 40.0, 22.0 ],
                    "text": "date"
                }
            },
            {
                "box": {
                    "id": "obj-405",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 1580.5556309223175, 1950.0000929832458, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-406",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "int", "int", "int" ],
                    "patching_rect": [ 1772.222306728363, 2019.4445407390594, 77.0, 22.0 ],
                    "text": "unpack 0 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-407",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1858.333421945572, 2194.4445490837097, 81.0, 22.0 ],
                    "text": "prepend write"
                }
            },
            {
                "box": {
                    "id": "obj-408",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1769.4445288181305, 1916.6667580604553, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-409",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1927.7778697013855, 2133.3334350585938, 32.0, 22.0 ],
                    "text": "print"
                }
            },
            {
                "box": {
                    "format": 8,
                    "id": "obj-410",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1908.3334243297577, 2158.3334362506866, 337.9310522079468, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-411",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 1741.666749715805, 1880.5556452274323, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-412",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1741.666749715805, 1916.6667580604553, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-413",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1858.333421945572, 2019.4445407390594, 209.0, 22.0 ],
                    "text": "/Users/zoe/mastersdata/to_be_sorted"
                }
            },
            {
                "box": {
                    "id": "obj-414",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 1808.333419561386, 1880.5556452274323, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-415",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1808.333419561386, 1905.5556464195251, 228.0, 22.0 ],
                    "text": "set /Users/zoe/mastersdata/to_be_sorted"
                }
            },
            {
                "box": {
                    "id": "obj-416",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1858.333421945572, 2133.3334350585938, 57.0, 22.0 ],
                    "text": "tosymbol"
                }
            },
            {
                "box": {
                    "id": "obj-417",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 1858.333421945572, 2094.444544315338, 174.0, 22.0 ],
                    "text": "combine 0 0 .csv @triggers 1 2"
                }
            },
            {
                "box": {
                    "id": "obj-418",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1886.1112010478973, 1950.0000929832458, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-419",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "patching_rect": [ 1886.1112010478973, 1972.2223162651062, 90.0, 22.0 ],
                    "text": "opendialog fold"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-420",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1580.5556309223175, 2019.4445407390594, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 8,
                    "id": "obj-421",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2019.4445407390594, 2019.4445407390594, 103.63635993003845, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-423",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1219.4445025920868, 1455.555624961853, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "format": 8,
                    "id": "obj-424",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1050.0000500679016, 1327.777841091156, 242.39129972457886, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-425",
                    "maxclass": "newobj",
                    "numinlets": 5,
                    "numoutlets": 4,
                    "outlettype": [ "int", "", "", "int" ],
                    "patching_rect": [ 1438.8889575004578, 1780.5556404590607, 102.0, 22.0 ],
                    "text": "counter 1 100000"
                }
            },
            {
                "box": {
                    "id": "obj-426",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1747.2223055362701, 1950.0000929832458, 32.0, 22.0 ],
                    "text": "date"
                }
            },
            {
                "box": {
                    "id": "obj-427",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1594.4445204734802, 1977.7778720855713, 35.0, 22.0 ],
                    "text": "clear"
                }
            },
            {
                "box": {
                    "id": "obj-428",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "bang", "" ],
                    "patching_rect": [ 1638.888967037201, 1902.7778685092926, 44.0, 22.0 ],
                    "text": "sel 1 0"
                }
            },
            {
                "box": {
                    "id": "obj-429",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "int", "int", "int" ],
                    "patching_rect": [ 1688.8889694213867, 2019.4445407390594, 77.0, 22.0 ],
                    "text": "unpack 0 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-430",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "list", "list", "int" ],
                    "patching_rect": [ 1747.2223055362701, 1972.2223162651062, 40.0, 22.0 ],
                    "text": "date"
                }
            },
            {
                "box": {
                    "id": "obj-431",
                    "maxclass": "gswitch2",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1969.4445383548737, 1863.888977766037, 39.0, 32.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-432",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 4,
                    "outlettype": [ "", "", "", "" ],
                    "patching_rect": [ 1986.111205816269, 2225.0001060962677, 83.0, 22.0 ],
                    "saved_object_attributes": {
                        "embed": 0,
                        "precision": 6
                    },
                    "text": "coll pondering"
                }
            },
            {
                "box": {
                    "id": "obj-433",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1633.3334112167358, 2050.0000977516174, 246.0, 22.0 ],
                    "text": "sprintf pondering-%ld-%ld-%ld--%ld-%ld-%ld"
                }
            },
            {
                "box": {
                    "id": "obj-434",
                    "maxclass": "newobj",
                    "numinlets": 14,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1550.0000739097595, 1780.5556404590607, 431.4285817146301, 22.0 ],
                    "text": "join 14 @triggers 0"
                }
            },
            {
                "box": {
                    "id": "obj-435",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 608.3333623409271, 1450.000069141388, 47.0, 22.0 ],
                    "text": "clocker"
                }
            },
            {
                "box": {
                    "id": "obj-436",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1302.777839899063, 1619.4445216655731, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1690.8695335388184, 369.1666566133499, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1023.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-437",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1025.0000488758087, 1619.4445216655731, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1357.1738877296448, 369.1666566133499, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1023.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-439",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1986.111205816269, 1619.4445216655731, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 725.7407184243202, 369.4444338083267, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1023.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-440",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "int", "int" ],
                    "patching_rect": [ 1863.888977766037, 1563.8889634609222, 67.0, 22.0 ],
                    "text": "unpack 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-441",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1608.333410024643, 1619.4445216655731, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 391.66665530204773, 369.4444338083267, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1023.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-442",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1102.77783036232, 1402.7778446674347, 71.0, 22.0 ],
                    "text": "fromsymbol"
                }
            },
            {
                "box": {
                    "id": "obj-443",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [ "", "", "" ],
                    "patching_rect": [ 1011.111159324646, 1366.6667318344116, 82.0, 22.0 ],
                    "text": "route left right"
                }
            },
            {
                "box": {
                    "id": "obj-444",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1011.111159324646, 1402.7778446674347, 71.0, 22.0 ],
                    "text": "fromsymbol"
                }
            },
            {
                "box": {
                    "id": "obj-445",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1050.0000500679016, 1294.4445061683655, 109.72222745418549, 20.0 ],
                    "text": "Initialisation patch!"
                }
            },
            {
                "box": {
                    "id": "obj-446",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
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
                        "rect": [ 59.0, 114.0, 1000.0, 690.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-46",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 213.0, 285.0, 291.0, 20.0 ],
                                    "text": "incase both micro controllers are on, only work with L"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "linecount": 3,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 285.0, 100.0, 150.0, 47.0 ],
                                    "text": "Using the same insole_ble.js file as in section 2!"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 285.0, 150.0, 150.0, 33.0 ],
                                    "text": "Initially working with \"L\" microcontroller!"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 137.0, 192.5, 63.0, 22.0 ],
                                    "text": "script stop"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-39",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 58.0, 192.5, 64.0, 22.0 ],
                                    "text": "script start"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 188.0, 325.0, 150.0, 20.0 ],
                                    "text": "String -> number"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 317.0, 192.5, 150.0, 33.0 ],
                                    "text": "Library that talks with bluetooth"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 50.0, 125.0, 157.0, 22.0 ],
                                    "text": "script npm install noble-mac"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 240.0, 243.31999999999994, 150.0, 33.0 ],
                                    "text": "Control a local node.js script through max"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 85.91000000000003, 248.82, 137.0, 22.0 ],
                                    "saved_object_attributes": {
                                        "autostart": 0,
                                        "defer": 0,
                                        "node_bin_path": "",
                                        "npm_bin_path": "",
                                        "watch": 0
                                    },
                                    "text": "node.script insole_ble.js",
                                    "textfile": {
                                        "filename": "insole_ble.js",
                                        "flags": 0,
                                        "embed": 0,
                                        "autowatch": 1
                                    }
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-67",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 58.0, 40.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-68",
                                    "index": 2,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 137.0, 40.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-69",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 85.91000000000003, 309.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "source": [ "obj-39", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-69", 0 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-39", 0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-68", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "order": 0,
                                    "source": [ "obj-8", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-39", 0 ],
                                    "order": 1,
                                    "source": [ "obj-8", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 1011.111159324646, 1294.4445061683655, 33.600000500679016, 22.0 ],
                    "text": "p"
                }
            },
            {
                "box": {
                    "id": "obj-447",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1377.7778434753418, 1594.4445204734802, 96.0, 20.0 ],
                    "text": "TOE AND HEEL"
                }
            },
            {
                "box": {
                    "id": "obj-448",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1125.0000536441803, 1594.4445204734802, 40.66666787862778, 20.0 ],
                    "text": "HEEL"
                }
            },
            {
                "box": {
                    "id": "obj-449",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "int", "int" ],
                    "patching_rect": [ 1250.0000596046448, 1566.6667413711548, 67.0, 22.0 ],
                    "text": "unpack 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-450",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1250.0000596046448, 1525.0000727176666, 75.29412078857422, 20.0 ],
                    "text": "LEFT FOOT"
                }
            },
            {
                "box": {
                    "id": "obj-451",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "bang", "" ],
                    "patching_rect": [ 658.3333647251129, 1450.000069141388, 44.0, 22.0 ],
                    "text": "sel 1 0"
                }
            },
            {
                "box": {
                    "id": "obj-452",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 608.3333623409271, 1372.2222876548767, 24.0, 24.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1129.1780224144459, 461.5217308998108, 47.727272272109985, 47.727272272109985 ]
                }
            },
            {
                "box": {
                    "angle": 270.0,
                    "bgcolor": [ 0.650980392156863, 0.650980392156863, 0.650980392156863, 0.247058823529412 ],
                    "id": "obj-453",
                    "maxclass": "panel",
                    "mode": 0,
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1541.666740179062, 1847.2223103046417, 722.7272468805313, 422.72725760936737 ],
                    "proportion": 0.39,
                    "saved_attribute_attributes": {
                        "bgfillcolor": {
                            "expression": "themecolor.live_spectrum_grid_lines"
                        }
                    }
                }
            },
            {
                "box": {
                    "id": "obj-280",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2019.4445407390594, 1286.1111724376678, 43.518340200185776, 20.0 ],
                    "text": "R heel"
                }
            },
            {
                "box": {
                    "id": "obj-281",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1950.0000929832458, 1286.1111724376678, 37.0, 20.0 ],
                    "text": "R toe"
                }
            },
            {
                "box": {
                    "id": "obj-279",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1872.2223114967346, 1286.1111724376678, 43.518340200185776, 20.0 ],
                    "text": "L heel"
                }
            },
            {
                "box": {
                    "id": "obj-278",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1808.333419561386, 1286.1111724376678, 36.90476247668266, 20.0 ],
                    "text": "L toe"
                }
            },
            {
                "box": {
                    "id": "obj-276",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1741.666749715805, 1358.333398103714, 44.00324672460556, 20.0 ],
                    "text": "upper"
                }
            },
            {
                "box": {
                    "id": "obj-275",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1750.0000834465027, 1327.777841091156, 38.09523868560791, 20.0 ],
                    "text": "lower"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-273",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2016.666762828827, 1358.333398103714, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-271",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2016.666762828827, 1327.777841091156, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-269",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1941.6667592525482, 1358.333398103714, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-267",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1941.6667592525482, 1327.777841091156, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-265",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1869.444533586502, 1358.333398103714, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-263",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1869.444533586502, 1327.777841091156, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-261",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1800.0000858306885, 1358.333398103714, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-259",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1800.0000858306885, 1327.777841091156, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-257",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 13,
                    "outlettype": [ "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 1604.3477954864502, 895.652156829834, 221.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-256",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1286.9564971923828, 599.9999885559082, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-254",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1621.7390995025635, 686.9565086364746, 29.5, 22.0 ],
                    "text": "0"
                }
            },
            {
                "box": {
                    "id": "obj-252",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 1621.7390995025635, 660.8695526123047, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-251",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 491.3043384552002, 360.8695583343506, 29.5, 22.0 ],
                    "text": "2"
                }
            },
            {
                "box": {
                    "id": "obj-249",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1665.2173595428467, 795.6521587371826, 150.0, 33.0 ],
                    "text": "calibrate the data, then save it"
                }
            },
            {
                "box": {
                    "id": "obj-247",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 1630.4347515106201, 795.6521587371826, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-246",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1639.1304035186768, 830.4347667694092, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-244",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "bang", "" ],
                    "patching_rect": [ 1630.4347515106201, 765.2173767089844, 44.0, 22.0 ],
                    "text": "sel 1 0"
                }
            },
            {
                "box": {
                    "id": "obj-243",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1634.7825775146484, 713.0434646606445, 150.0, 33.0 ],
                    "text": "on-calibrated\noff-uncalibrated"
                }
            },
            {
                "box": {
                    "id": "obj-241",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1604.3477954864502, 717.3912906646729, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-239",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
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
                        "rect": [ 134.0, 190.0, 710.0, 667.0 ],
                        "visible": 1,
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-18",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 747.2972474098206, 630.4053633213043, 35.0, 22.0 ],
                                    "text": "1000"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-11",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 821.0, 589.0, 58.0, 22.0 ],
                                    "text": "loadbang"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-9",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 821.0, 619.3613879680634, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-147",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "" ],
                                    "patching_rect": [ 717.7570037841797, 832.0000247955322, 44.0, 22.0 ],
                                    "text": "sel 1 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-145",
                                    "maxclass": "toggle",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 717.7570037841797, 802.6666905879974, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-140",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 657.8718763589859, 913.9037166237831, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-136",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 717.7570037841797, 852.6666928529739, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-125",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "bang" ],
                                    "patching_rect": [ 717.7570037841797, 878.6666928529739, 32.0, 22.0 ],
                                    "text": "t b b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-112",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 690.1851640343666, 683.8709726333618, 29.5, 22.0 ],
                                    "text": "0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-96",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 134.15887758135796, 42.68751072883606, 55.14018648862839, 20.0 ],
                                    "text": "save file"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-94",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 146.72897082567215, 68.2242985367775, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-93",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 370.72368067502975, 144.75001096725464, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-91",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 611.7264863848686, 1119.3181711435318, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-67",
                                    "maxclass": "number",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 736.4485924243927, 683.8709726333618, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-54",
                                    "maxclass": "number",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 644.8718763589859, 780.128303706646, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 5,
                                    "numoutlets": 4,
                                    "outlettype": [ "int", "", "", "int" ],
                                    "patching_rect": [ 645.1851640343666, 752.5925679206848, 79.0, 22.0 ],
                                    "text": "counter 1000"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-50",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 645.1851640343666, 723.7036799788475, 56.0, 22.0 ],
                                    "text": "metro 20"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-49",
                                    "maxclass": "toggle",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 645.1851640343666, 682.8709726333618, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-76",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "", "", "", "" ],
                                    "patching_rect": [ 709.3457888960838, 314.0186891555786, 73.0, 22.0 ],
                                    "saved_object_attributes": {
                                        "embed": 0,
                                        "precision": 6
                                    },
                                    "text": "coll rawdata"
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
                                    "patching_rect": [ 916.8224228024483, 482.2429869174957, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-75",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 897.1962547302246, 450.4672862291336, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-72",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 856.074759721756, 482.2429869174957, 50.0, 22.0 ]
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
                                    "patching_rect": [ 836.4485916495323, 450.4672862291336, 50.0, 22.0 ]
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
                                    "patching_rect": [ 794.392517209053, 482.2429869174957, 50.0, 22.0 ]
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
                                    "patching_rect": [ 775.70092856884, 450.4672862291336, 50.0, 22.0 ]
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
                                    "patching_rect": [ 736.4485924243927, 482.2429869174957, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-68",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 717.7570037841797, 450.4672862291336, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 8,
                                    "outlettype": [ "float", "float", "float", "float", "float", "float", "float", "float" ],
                                    "patching_rect": [ 759.813078224659, 406.542052924633, 154.0, 22.0 ],
                                    "text": "unpack 0. 0. 0. 0. 0. 0. 0. 0."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-64",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 672.8971910476685, 319.6261657476425, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-62",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 685.0467236638069, 286.91588562726974, 39.0, 22.0 ],
                                    "text": "dump"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 696.2616768479347, 254.20560550689697, 35.0, 22.0 ],
                                    "text": "clear"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "bang" ],
                                    "patching_rect": [ 672.8971910476685, 223.3644842505455, 42.0, 22.0 ],
                                    "text": "t b b b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-57",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 759.813078224659, 373.83177280426025, 129.0, 22.0 ],
                                    "saved_object_attributes": {
                                        "filename": "calculatingbounds.js",
                                        "parameter_enable": 0
                                    },
                                    "text": "js calculatingbounds.js"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 664.8971910476685, 147.99065309762955, 50.0, 20.0 ],
                                    "text": "trigger"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-14",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 672.8971910476685, 183.17756867408752, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-151",
                                    "maxclass": "newobj",
                                    "numinlets": 0,
                                    "numoutlets": 0,
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
                                        "rect": [ 2538.0, 39.0, 1000.0, 738.0 ],
                                        "boxes": [
                                            {
                                                "box": {
                                                    "id": "obj-33",
                                                    "maxclass": "message",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 1786.6668956279755, 515.2381612658501, 43.0, 22.0 ],
                                                    "text": "sort -1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-24",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "bang", "bang" ],
                                                    "patching_rect": [ 1862.8573815822601, 327.6190896034241, 32.0, 22.0 ],
                                                    "text": "t b b"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-19",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 2,
                                                    "outlettype": [ "bang", "" ],
                                                    "patching_rect": [ 1829.5240439772606, 289.52384662628174, 31.0, 22.0 ],
                                                    "text": "t b s"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-13",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 1876.19071662426, 418.0952916741371, 97.0, 20.0 ],
                                                    "text": "L foot ascending"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-8",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 1893.333575963974, 389.52385944128036, 97.0, 20.0 ],
                                                    "text": "L toe ascending"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-23",
                                                    "maxclass": "message",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 1797.1430874466896, 472.38101291656494, 53.0, 22.0 ],
                                                    "text": "sort -1 4"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-22",
                                                    "maxclass": "message",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 1807.6192792654037, 443.8095806837082, 53.0, 22.0 ],
                                                    "text": "sort -1 3"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-21",
                                                    "maxclass": "message",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 1819.0478521585464, 417.14291059970856, 53.0, 22.0 ],
                                                    "text": "sort -1 2"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-20",
                                                    "maxclass": "message",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 1841.9049979448318, 387.61909729242325, 53.0, 22.0 ],
                                                    "text": "sort -1 1"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-18",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 4,
                                                    "outlettype": [ "", "", "", "" ],
                                                    "patching_rect": [ 1835.238330423832, 551.4286420941353, 77.0, 22.0 ],
                                                    "saved_object_attributes": {
                                                        "embed": 0,
                                                        "precision": 6
                                                    },
                                                    "text": "coll walkdata"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-17",
                                                    "maxclass": "newobj",
                                                    "numinlets": 1,
                                                    "numoutlets": 5,
                                                    "outlettype": [ "bang", "bang", "bang", "bang", "bang" ],
                                                    "patching_rect": [ 1786.6668956279755, 260.952414393425, 62.0, 22.0 ],
                                                    "text": "t b b b b b"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-15",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 2225.714570939541, 400.95243233442307, 66.80851203203201, 20.0 ],
                                                    "text": "low index"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-16",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 2019.0478777885437, 400.0000512599945, 199.0, 22.0 ],
                                                    "text": "expr int(($i1 * (5 + (15 * $f2))) / 100)"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-12",
                                                    "maxclass": "newobj",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 2060.9526450634003, 372.3810001015663, 203.0, 22.0 ],
                                                    "text": "expr int(($i1 * (95 - (15 * $f2))) / 100)"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-56",
                                                    "maxclass": "message",
                                                    "numinlets": 2,
                                                    "numoutlets": 1,
                                                    "outlettype": [ "" ],
                                                    "patching_rect": [ 30.0, 132.8571560382843, 33.0, 22.0 ],
                                                    "text": "style"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-14",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 676.1904866695404, 369.04762476682663, 66.80851203203201, 20.0 ],
                                                    "text": "high index"
                                                }
                                            },
                                            {
                                                "box": {
                                                    "id": "obj-6",
                                                    "maxclass": "comment",
                                                    "numinlets": 1,
                                                    "numoutlets": 0,
                                                    "patching_rect": [ 2712.0, 1791.0, 150.0, 20.0 ],
                                                    "text": "ahhh"
                                                }
                                            }
                                        ],
                                        "lines": [
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-19", 0 ],
                                                    "source": [ "obj-17", 4 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-21", 0 ],
                                                    "source": [ "obj-17", 3 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-22", 0 ],
                                                    "source": [ "obj-17", 2 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-23", 0 ],
                                                    "source": [ "obj-17", 1 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-33", 0 ],
                                                    "source": [ "obj-17", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-20", 0 ],
                                                    "source": [ "obj-19", 1 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-24", 0 ],
                                                    "source": [ "obj-19", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-18", 0 ],
                                                    "midpoints": [ 1851.4049979448318, 412.3810001015663, 1869.9526450634003, 412.3810001015663, 1869.9526450634003, 506.5935146396514, 1844.738330423832, 506.5935146396514 ],
                                                    "source": [ "obj-20", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-18", 0 ],
                                                    "midpoints": [ 1828.5478521585464, 439.3810001015663, 1857.9526450634003, 439.3810001015663, 1857.9526450634003, 507.9738693847321, 1844.738330423832, 507.9738693847321 ],
                                                    "source": [ "obj-21", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-18", 0 ],
                                                    "midpoints": [ 1817.1192792654037, 469.3810001015663, 1845.9526450634003, 469.3810001015663, 1845.9526450634003, 509.8172684083693, 1844.738330423832, 509.8172684083693 ],
                                                    "source": [ "obj-22", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-18", 0 ],
                                                    "midpoints": [ 1806.6430874466896, 505.90443452843465, 1844.738330423832, 505.90443452843465 ],
                                                    "source": [ "obj-23", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-12", 0 ],
                                                    "midpoints": [ 1885.3573815822601, 362.0489688515663, 2070.4526450634003, 362.0489688515663 ],
                                                    "source": [ "obj-24", 1 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-16", 0 ],
                                                    "midpoints": [ 1872.3573815822601, 373.3810001015663, 2028.5478777885437, 373.3810001015663 ],
                                                    "source": [ "obj-24", 0 ]
                                                }
                                            },
                                            {
                                                "patchline": {
                                                    "destination": [ "obj-18", 0 ],
                                                    "source": [ "obj-33", 0 ]
                                                }
                                            }
                                        ]
                                    },
                                    "patching_rect": [ 1483.1775586009026, 144.75001072883606, 179.0, 22.0 ],
                                    "text": "p percentiles"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-148",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 18.657177686691284, 680.1980218291283, 90.58823907375336, 20.0 ],
                                    "text": "storing the file"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-127",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 210.736386179924, 784.1584181785583, 31.0, 22.0 ],
                                    "text": "time"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-128",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "list", "list", "int" ],
                                    "patching_rect": [ 210.736386179924, 804.9504974484444, 40.0, 22.0 ],
                                    "text": "date"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-120",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "int", "int", "int" ],
                                    "patching_rect": [ 176.57797023653984, 850.0000025331974, 77.0, 22.0 ],
                                    "text": "unpack 0 0 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-109",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 263.70668336749077, 1022.2772307693958, 81.0, 22.0 ],
                                    "text": "prepend write"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-102",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 172.61757418513298, 748.0198042094707, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "format": 8,
                                    "id": "obj-130",
                                    "maxclass": "number",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 288.0, 994.059408903122, 398.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-138",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "bang" ],
                                    "patching_rect": [ 145.88490083813667, 712.8712892532349, 32.0, 22.0 ],
                                    "text": "t b b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-137",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 145.88490083813667, 748.0198042094707, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-134",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 263.70668336749077, 850.0000025331974, 212.0, 22.0 ],
                                    "text": "/Users/zoe/mastersdata/to_be_sorted/"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-131",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 263.70668336749077, 724.2574279010296, 58.0, 22.0 ],
                                    "text": "loadbang"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-132",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 263.70668336749077, 749.0099032223225, 231.0, 22.0 ],
                                    "text": "set /Users/zoe/mastersdata/to_be_sorted/"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-118",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 263.70668336749077, 959.9009929597378, 57.0, 22.0 ],
                                    "text": "tosymbol"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-133",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 263.70668336749077, 927.2277255356312, 174.0, 22.0 ],
                                    "text": "combine 0 0 .csv @triggers 1 2"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-135",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 288.9542081952095, 783.1683191657066, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-105",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "patching_rect": [ 288.9542081952095, 804.9504974484444, 90.0, 22.0 ],
                                    "text": "opendialog fold"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-106",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 154.7957919538021, 784.1584181785583, 32.0, 22.0 ],
                                    "text": "date"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-142",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "int", "int", "int" ],
                                    "patching_rect": [ 92.91460365056992, 850.0000025331974, 77.0, 22.0 ],
                                    "text": "unpack 0 0 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-143",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "list", "list", "int" ],
                                    "patching_rect": [ 154.7957919538021, 804.9504974484444, 40.0, 22.0 ],
                                    "text": "date"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-144",
                                    "maxclass": "newobj",
                                    "numinlets": 6,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 37.96410843729973, 890.0990125536919, 236.0, 22.0 ],
                                    "text": "sprintf %ld-%ld-%ld--%ld-%ld-%ld-updated"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-126",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 146.8749998509884, 587.128714621067, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-124",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 251.5625, 246.87501072883606, 29.5, 22.0 ],
                                    "text": "+ 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-123",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 207.8125, 395.31251072883606, 29.5, 22.0 ],
                                    "text": "- 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-122",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 240.625, 365.62501072883606, 29.5, 22.0 ],
                                    "text": "- 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-121",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 196.875, 446.87501072883606, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-119",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 196.96968734264374, 524.7474491000175, 53.0, 22.0 ],
                                    "text": "sort -1 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-117",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 285.125, 71.19047746062279, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-115",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 258.7561883032322, 619.3069325387478, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-113",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 181.25, 143.75001072883606, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-111",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 5,
                                    "outlettype": [ "bang", "bang", "bang", "bang", "bang" ],
                                    "patching_rect": [ 229.93420833349228, 105.26315689086914, 62.0, 22.0 ],
                                    "text": "t b b b b b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-110",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 180.5383662879467, 650.9901009500027, 35.0, 22.0 ],
                                    "text": "clear"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-108",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 241.92450508475304, 584.1584175825119, 72.0, 22.0 ],
                                    "text": "prepend set"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-107",
                                    "linecount": 2,
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 241.92450508475304, 650.9901009500027, 188.0, 35.0 ],
                                    "text": "0 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-97",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "", "", "", "" ],
                                    "patching_rect": [ 611.7264863848686, 1071.2871319055557, 95.0, 22.0 ],
                                    "saved_object_attributes": {
                                        "embed": 0,
                                        "precision": 6
                                    },
                                    "text": "coll newrawdata"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-95",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 396.875, 451.56251072883606, 227.52291679382324, 20.0 ],
                                    "text": "keeping the pressure values"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 743.3885698914528, 112.14953184127808, 65.78947305679321, 20.0 ],
                                    "text": "sensitivity"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-58",
                                    "index": 3,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 761.1455790996552, 142.99065309762955, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-53",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 293.9047032594681, 613.8613879680634, 357.2308762073517, 33.0 ],
                                    "text": "time elapsed, left foot toe, left foor heel, right foot toe, right foot heel, left foot toe lower bound, left foot toe upper bound, etc. "
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-41",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 13,
                                    "outlettype": [ "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float", "float" ],
                                    "patching_rect": [ 240.625, 450.00001072883606, 145.0, 22.0 ],
                                    "text": "unpack f f f f f f f f f f f f f"
                                }
                            },
                            {
                                "box": {
                                    "format": 8,
                                    "id": "obj-40",
                                    "maxclass": "number",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 240.625, 423.43751072883606, 375.5395817756653, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-36",
                                    "maxclass": "newobj",
                                    "numinlets": 14,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 241.92450508475304, 553.9603976905346, 155.5, 22.0 ],
                                    "text": "pack i f f f f f f f f f f f f f"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-35",
                                    "maxclass": "number",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 240.625, 332.81251072883606, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-33",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "", "", "", "" ],
                                    "patching_rect": [ 240.625, 395.31251072883606, 73.0, 22.0 ],
                                    "saved_object_attributes": {
                                        "embed": 0,
                                        "precision": 6
                                    },
                                    "text": "coll rawdata"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-21",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 264.0625, 303.12501072883606, 111.11111640930176, 20.0 ],
                                    "text": "sends many bangs"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-19",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 220.3125, 143.75001072883606, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-17",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 251.5625, 275.00001072883606, 77.33990687131882, 22.0 ],
                                    "text": "1"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-15",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 251.5625, 220.31251072883606, 77.33990687131882, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 220.3125, 301.56251072883606, 40.0, 22.0 ],
                                    "text": "uzi 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "maxclass": "button",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 251.5625, 144.75001096725464, 24.0, 24.0 ]
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 251.5625, 169.75001072883606, 41.0, 22.0 ],
                                    "text": "length"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 4,
                                    "outlettype": [ "", "", "", "" ],
                                    "patching_rect": [ 251.5625, 193.10527366399765, 73.0, 22.0 ],
                                    "saved_object_attributes": {
                                        "embed": 0,
                                        "precision": 6
                                    },
                                    "text": "coll rawdata"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 203.125, 29.68751072883606, 106.0, 33.0 ],
                                    "text": "bang from update csv file button"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 2400.0, 2091.0, 150.0, 20.0 ],
                                    "text": "ahhh"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-1",
                                    "index": 2,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 229.93420833349228, 68.19047746062279, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "angle": 270.0,
                                    "bgcolor": [ 0.737254901960784, 0.737254901960784, 0.737254901960784, 0.329411764705882 ],
                                    "id": "obj-146",
                                    "maxclass": "panel",
                                    "mode": 0,
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 18.657177686691284, 702.9702991247177, 588.6397435069084, 357.64707374572754 ],
                                    "proportion": 0.5,
                                    "saved_attribute_attributes": {
                                        "bgfillcolor": {
                                            "expression": "themecolor.live_spectrum_default_color"
                                        }
                                    }
                                }
                            },
                            {
                                "box": {
                                    "angle": 270.0,
                                    "bgcolor": [ 0.737254901960784, 0.737254901960784, 0.737254901960784, 0.329411764705882 ],
                                    "id": "obj-149",
                                    "maxclass": "panel",
                                    "mode": 0,
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 636.4485931992531, 95.32710206508636, 368.22429621219635, 440.18691247701645 ],
                                    "proportion": 0.5,
                                    "saved_attribute_attributes": {
                                        "bgfillcolor": {
                                            "expression": "themecolor.live_spectrum_default_color"
                                        }
                                    }
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-111", 0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "source": [ "obj-10", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-106", 0 ],
                                    "midpoints": [ 182.11757418513298, 772.9390436112881, 164.96447455883026, 772.9390436112881, 164.96447455883026, 778.9390436112881, 164.2957919538021, 778.9390436112881 ],
                                    "order": 1,
                                    "source": [ "obj-102", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-127", 0 ],
                                    "midpoints": [ 182.11757418513298, 778.9390436112881, 220.236386179924, 778.9390436112881 ],
                                    "order": 0,
                                    "source": [ "obj-102", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-134", 0 ],
                                    "midpoints": [ 298.4542081952095, 829.9390436112881, 273.20668336749077, 829.9390436112881 ],
                                    "source": [ "obj-105", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-143", 0 ],
                                    "source": [ "obj-106", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-97", 0 ],
                                    "midpoints": [ 251.42450508475304, 693.9307234250009, 621.2264863848686, 693.9307234250009 ],
                                    "source": [ "obj-107", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-107", 0 ],
                                    "order": 1,
                                    "source": [ "obj-108", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-115", 0 ],
                                    "order": 0,
                                    "source": [ "obj-108", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-97", 0 ],
                                    "midpoints": [ 273.20668336749077, 1056.1880778372288, 621.2264863848686, 1056.1880778372288 ],
                                    "source": [ "obj-109", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-18", 0 ],
                                    "order": 1,
                                    "source": [ "obj-11", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-9", 0 ],
                                    "order": 0,
                                    "source": [ "obj-11", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-97", 0 ],
                                    "midpoints": [ 190.0383662879467, 693.4638229310513, 621.2264863848686, 693.4638229310513 ],
                                    "source": [ "obj-110", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-113", 0 ],
                                    "midpoints": [ 282.4342083334923, 138.38824560504872, 190.75, 138.38824560504872 ],
                                    "source": [ "obj-111", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-12", 0 ],
                                    "source": [ "obj-111", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 0 ],
                                    "midpoints": [ 271.6842083334923, 138.0, 648.0, 138.0, 648.0, 180.0, 682.3971910476685, 180.0 ],
                                    "source": [ "obj-111", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-19", 0 ],
                                    "midpoints": [ 250.18420833349228, 139.52970489941072, 229.8125, 139.52970489941072 ],
                                    "source": [ "obj-111", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-93", 0 ],
                                    "midpoints": [ 239.43420833349228, 138.75534530170262, 380.22368067502975, 138.75534530170262 ],
                                    "source": [ "obj-111", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 3 ],
                                    "source": [ "obj-112", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-110", 0 ],
                                    "midpoints": [ 190.75, 258.2757450938225, 190.0383662879467, 258.2757450938225 ],
                                    "source": [ "obj-113", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-107", 0 ],
                                    "source": [ "obj-115", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-111", 0 ],
                                    "source": [ "obj-117", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-109", 0 ],
                                    "order": 1,
                                    "source": [ "obj-118", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-130", 0 ],
                                    "midpoints": [ 273.20668336749077, 987.843798071146, 297.5, 987.843798071146 ],
                                    "order": 0,
                                    "source": [ "obj-118", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-97", 0 ],
                                    "midpoints": [ 206.46968734264374, 636.4638229310513, 226.42878624796867, 636.4638229310513, 226.42878624796867, 693.4638229310513, 621.2264863848686, 693.4638229310513 ],
                                    "source": [ "obj-119", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-10", 0 ],
                                    "source": [ "obj-12", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-144", 5 ],
                                    "midpoints": [ 244.07797023653984, 883.9390436112881, 264.4641084372997, 883.9390436112881 ],
                                    "source": [ "obj-120", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-144", 4 ],
                                    "midpoints": [ 215.07797023653984, 882.1880778372288, 221.06410843729972, 882.1880778372288 ],
                                    "source": [ "obj-120", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-144", 3 ],
                                    "midpoints": [ 186.07797023653984, 873.1880778372288, 180.11026859283447, 873.1880778372288, 180.11026859283447, 885.1880778372288, 177.66410843729972, 885.1880778372288 ],
                                    "source": [ "obj-120", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-119", 0 ],
                                    "source": [ "obj-121", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-33", 0 ],
                                    "source": [ "obj-122", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 0 ],
                                    "midpoints": [ 217.3125, 475.03716030018404, 251.42450508475304, 475.03716030018404 ],
                                    "source": [ "obj-123", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 1 ],
                                    "order": 0,
                                    "source": [ "obj-124", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-17", 0 ],
                                    "order": 1,
                                    "source": [ "obj-124", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-112", 0 ],
                                    "midpoints": [ 727.2570037841797, 903.3750011846423, 630.0, 903.3750011846423, 630.0, 669.0, 699.6851640343666, 669.0 ],
                                    "source": [ "obj-125", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-140", 0 ],
                                    "midpoints": [ 740.2570037841797, 903.3606381621794, 667.3718763589859, 903.3606381621794 ],
                                    "source": [ "obj-125", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-138", 0 ],
                                    "midpoints": [ 156.3749998509884, 612.7174897491932, 155.38490083813667, 612.7174897491932 ],
                                    "source": [ "obj-126", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-128", 0 ],
                                    "source": [ "obj-127", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-120", 0 ],
                                    "midpoints": [ 230.736386179924, 829.9390436112881, 186.07797023653984, 829.9390436112881 ],
                                    "source": [ "obj-128", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-121", 0 ],
                                    "midpoints": [ 240.3125, 329.1113847747911, 206.488505264977, 329.1113847747911, 206.488505264977, 347.40878556552343, 206.53150291088969, 347.40878556552343, 206.53150291088969, 432.2757450938225, 206.375, 432.2757450938225 ],
                                    "source": [ "obj-13", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-35", 0 ],
                                    "source": [ "obj-13", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-132", 0 ],
                                    "source": [ "obj-131", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-134", 0 ],
                                    "midpoints": [ 273.20668336749077, 772.9390436112881, 273.20668336749077, 772.9390436112881 ],
                                    "source": [ "obj-132", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-118", 0 ],
                                    "midpoints": [ 273.20668336749077, 949.1263788640499, 273.20668336749077, 949.1263788640499 ],
                                    "source": [ "obj-133", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-133", 0 ],
                                    "source": [ "obj-134", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-105", 0 ],
                                    "source": [ "obj-135", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-125", 0 ],
                                    "source": [ "obj-136", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-134", 0 ],
                                    "midpoints": [ 155.38490083813667, 772.9390436112881, 273.20668336749077, 772.9390436112881 ],
                                    "source": [ "obj-137", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-102", 0 ],
                                    "midpoints": [ 168.38490083813667, 742.637446731329, 182.11757418513298, 742.637446731329 ],
                                    "source": [ "obj-138", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-137", 0 ],
                                    "midpoints": [ 155.38490083813667, 736.637446731329, 155.38490083813667, 736.637446731329 ],
                                    "source": [ "obj-138", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "source": [ "obj-14", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-49", 0 ],
                                    "midpoints": [ 667.3718763589859, 947.7868903091876, 630.0, 947.7868903091876, 630.0, 678.0, 654.6851640343666, 678.0 ],
                                    "source": [ "obj-140", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-144", 2 ],
                                    "midpoints": [ 160.41460365056992, 873.1880778372288, 135.11026859283447, 873.1880778372288, 135.11026859283447, 885.1880778372288, 134.26410843729974, 885.1880778372288 ],
                                    "source": [ "obj-142", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-144", 0 ],
                                    "midpoints": [ 131.41460365056992, 880.4097884688526, 47.96447455883026, 880.4097884688526, 47.96447455883026, 883.9390436112881, 47.46410843729973, 883.9390436112881 ],
                                    "source": [ "obj-142", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-144", 1 ],
                                    "midpoints": [ 102.41460365056992, 871.9390436112881, 90.86410843729973, 871.9390436112881 ],
                                    "source": [ "obj-142", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-142", 0 ],
                                    "midpoints": [ 164.2957919538021, 829.9390436112881, 102.41460365056992, 829.9390436112881 ],
                                    "source": [ "obj-143", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-133", 1 ],
                                    "midpoints": [ 47.46410843729973, 919.1339001167798, 350.70668336749077, 919.1339001167798 ],
                                    "source": [ "obj-144", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-147", 0 ],
                                    "source": [ "obj-145", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-136", 0 ],
                                    "source": [ "obj-147", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-124", 0 ],
                                    "order": 1,
                                    "source": [ "obj-15", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-67", 0 ],
                                    "midpoints": [ 261.0625, 243.0, 183.0, 243.0, 183.0, 516.0, 618.0, 516.0, 618.0, 600.0, 745.9485924243927, 600.0 ],
                                    "order": 0,
                                    "source": [ "obj-15", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 1 ],
                                    "source": [ "obj-17", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-67", 0 ],
                                    "source": [ "obj-18", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-19", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-40", 0 ],
                                    "source": [ "obj-33", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-122", 0 ],
                                    "order": 0,
                                    "source": [ "obj-35", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-123", 0 ],
                                    "midpoints": [ 250.125, 359.0551570095122, 217.3125, 359.0551570095122 ],
                                    "order": 1,
                                    "source": [ "obj-35", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-108", 0 ],
                                    "source": [ "obj-36", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-57", 0 ],
                                    "midpoints": [ 705.7616768479347, 278.99065309762955, 769.313078224659, 278.99065309762955 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-41", 0 ],
                                    "source": [ "obj-40", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 5 ],
                                    "midpoints": [ 292.125, 489.3961133360863, 303.92450508475304, 489.3961133360863 ],
                                    "source": [ "obj-41", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 4 ],
                                    "midpoints": [ 281.625, 489.3961133360863, 293.42450508475304, 489.3961133360863 ],
                                    "source": [ "obj-41", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 3 ],
                                    "midpoints": [ 271.125, 489.3961133360863, 282.92450508475304, 489.3961133360863 ],
                                    "source": [ "obj-41", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 2 ],
                                    "midpoints": [ 260.625, 489.3961133360863, 272.42450508475304, 489.3961133360863 ],
                                    "source": [ "obj-41", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 1 ],
                                    "midpoints": [ 250.125, 489.3961133360863, 261.92450508475304, 489.3961133360863 ],
                                    "source": [ "obj-41", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-50", 0 ],
                                    "source": [ "obj-49", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "source": [ "obj-5", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-62", 0 ],
                                    "source": [ "obj-5", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-64", 0 ],
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "source": [ "obj-50", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-145", 0 ],
                                    "source": [ "obj-51", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-54", 0 ],
                                    "order": 0,
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-97", 0 ],
                                    "midpoints": [ 654.6851640343666, 1033.2951544448733, 621.2264863848686, 1033.2951544448733 ],
                                    "order": 1,
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "source": [ "obj-57", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-57", 0 ],
                                    "source": [ "obj-58", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-76", 0 ],
                                    "midpoints": [ 694.5467236638069, 308.99065309762955, 718.8457888960838, 308.99065309762955 ],
                                    "source": [ "obj-62", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-57", 0 ],
                                    "midpoints": [ 682.3971910476685, 359.99065309762955, 769.313078224659, 359.99065309762955 ],
                                    "source": [ "obj-64", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "midpoints": [ 769.313078224659, 441.3716070652008, 727.2570037841797, 441.3716070652008 ],
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-69", 0 ],
                                    "midpoints": [ 788.5987925103733, 437.1156541388482, 767.9981908202171, 437.1156541388482, 767.9981908202171, 473.99065309762955, 745.9485924243927, 473.99065309762955 ],
                                    "source": [ "obj-65", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-70", 0 ],
                                    "midpoints": [ 827.1702210818019, 473.99065309762955, 803.892517209053, 473.99065309762955 ],
                                    "source": [ "obj-65", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-71", 0 ],
                                    "source": [ "obj-65", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-72", 0 ],
                                    "midpoints": [ 865.7416496532304, 446.99065309762955, 887.9981908202171, 446.99065309762955, 887.9981908202171, 473.99065309762955, 865.574759721756, 473.99065309762955 ],
                                    "source": [ "obj-65", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-73", 0 ],
                                    "source": [ "obj-65", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-74", 0 ],
                                    "midpoints": [ 904.313078224659, 446.99065309762955, 893.9981908202171, 446.99065309762955, 893.9981908202171, 473.99065309762955, 926.3224228024483, 473.99065309762955 ],
                                    "source": [ "obj-65", 7 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-75", 0 ],
                                    "midpoints": [ 885.0273639389446, 443.99065309762955, 906.6962547302246, 443.99065309762955 ],
                                    "source": [ "obj-65", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 4 ],
                                    "midpoints": [ 745.9485924243927, 717.0, 714.6851640343666, 717.0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 6 ],
                                    "midpoints": [ 727.2570037841797, 483.0, 314.42450508475304, 483.0 ],
                                    "source": [ "obj-68", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 7 ],
                                    "midpoints": [ 745.9485924243927, 507.0, 408.0, 507.0, 408.0, 489.0, 324.92450508475304, 489.0 ],
                                    "source": [ "obj-69", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 9 ],
                                    "midpoints": [ 803.892517209053, 516.0, 408.0, 516.0, 408.0, 489.0, 345.92450508475304, 489.0 ],
                                    "source": [ "obj-70", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 8 ],
                                    "midpoints": [ 785.20092856884, 474.0, 723.0, 474.0, 723.0, 489.0, 335.42450508475304, 489.0 ],
                                    "source": [ "obj-71", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 11 ],
                                    "midpoints": [ 865.574759721756, 516.0, 408.0, 516.0, 408.0, 489.0, 366.92450508475304, 489.0 ],
                                    "source": [ "obj-72", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 10 ],
                                    "midpoints": [ 845.9485916495323, 477.0, 846.0, 477.0, 846.0, 516.0, 408.0, 516.0, 408.0, 489.0, 356.42450508475304, 489.0 ],
                                    "source": [ "obj-73", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 13 ],
                                    "midpoints": [ 926.3224228024483, 516.002833861392, 387.92450508475304, 516.002833861392 ],
                                    "source": [ "obj-74", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-36", 12 ],
                                    "midpoints": [ 906.6962547302246, 516.0, 408.0, 516.0, 408.0, 489.0, 377.42450508475304, 489.0 ],
                                    "source": [ "obj-75", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-57", 0 ],
                                    "midpoints": [ 718.8457888960838, 359.99065309762955, 769.313078224659, 359.99065309762955 ],
                                    "source": [ "obj-76", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-15", 0 ],
                                    "source": [ "obj-8", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-145", 0 ],
                                    "order": 0,
                                    "source": [ "obj-9", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-49", 0 ],
                                    "order": 1,
                                    "source": [ "obj-9", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-49", 0 ],
                                    "midpoints": [ 380.22368067502975, 288.0, 624.106709849555, 288.0, 624.106709849555, 447.0, 624.0, 447.0, 624.0, 600.0, 655.6287201703526, 600.0, 655.6287201703526, 669.0, 654.6851640343666, 669.0 ],
                                    "source": [ "obj-93", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-126", 0 ],
                                    "source": [ "obj-94", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-91", 0 ],
                                    "source": [ "obj-97", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 1604.3477954864502, 869.5652008056641, 91.0, 22.0 ],
                    "text": "p updatecsvlive"
                }
            },
            {
                "box": {
                    "id": "obj-238",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1491.3043193817139, 660.8695526123047, 91.27484345436096, 20.0 ],
                    "text": "Saving the file!"
                }
            },
            {
                "box": {
                    "id": "obj-234",
                    "linecount": 4,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1604.3477954864502, 604.3478145599365, 221.0, 60.0 ],
                    "text": "counter, time elapsed, left foot toe, left foor heel, right foot toe, right foot heel, left foot toe lower bound, left foot toe upper bound, etc. etc. "
                }
            },
            {
                "box": {
                    "id": "obj-232",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1908.6956157684326, 404.3478183746338, 96.0, 20.0 ],
                    "text": "TOE AND HEEL"
                }
            },
            {
                "box": {
                    "id": "obj-233",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1595.6521434783936, 413.04347038269043, 40.66666787862778, 20.0 ],
                    "text": "HEEL"
                }
            },
            {
                "box": {
                    "id": "obj-226",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 713.0434646606445, 447.826078414917, 52.161918342113495, 52.161918342113495 ]
                }
            },
            {
                "box": {
                    "id": "obj-224",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 4,
                    "outlettype": [ "", "", "", "" ],
                    "patching_rect": [ 491.3043384552002, 669.5652046203613, 239.53487515449524, 22.0 ],
                    "text": "gate 4"
                }
            },
            {
                "box": {
                    "fontsize": 12.0,
                    "id": "obj-223",
                    "maxclass": "live.tab",
                    "num_lines_patching": 5,
                    "num_lines_presentation": 0,
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "", "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 491.3043384552002, 404.3478183746338, 191.77214938402176, 231.64556658267975 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_enum": [ "closed", "calibration", "pacing", "conditionA", "conditionB" ],
                            "parameter_longname": "live.tab[1]",
                            "parameter_mmax": 4,
                            "parameter_modmode": 0,
                            "parameter_shortname": "live.tab",
                            "parameter_type": 2,
                            "parameter_unitstyle": 9
                        }
                    },
                    "varname": "live.tab[1]"
                }
            },
            {
                "box": {
                    "id": "obj-10",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 530.4347724914551, 773.913028717041, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-103",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 530.4347724914551, 743.4782466888428, 74.0, 22.0 ],
                    "text": "delay 30000"
                }
            },
            {
                "box": {
                    "id": "obj-100",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 530.4347724914551, 708.6956386566162, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-33",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1182.6086730957031, 1039.1304149627686, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-139",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 965.2173728942871, 791.3043327331543, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-127",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1130.4347610473633, 756.5217247009277, 31.0, 22.0 ],
                    "text": "time"
                }
            },
            {
                "box": {
                    "id": "obj-38",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "list", "list", "int" ],
                    "patching_rect": [ 1130.4347610473633, 782.6086807250977, 40.0, 22.0 ],
                    "text": "date"
                }
            },
            {
                "box": {
                    "id": "obj-40",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 904.3478088378906, 756.5217247009277, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-120",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "int", "int", "int" ],
                    "patching_rect": [ 1091.3043270111084, 821.7391147613525, 77.0, 22.0 ],
                    "text": "unpack 0 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-52",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1182.6086730957031, 999.9999809265137, 81.0, 22.0 ],
                    "text": "prepend write"
                }
            },
            {
                "box": {
                    "id": "obj-53",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1091.3043270111084, 717.3912906646729, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-54",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1243.4782371520996, 934.7825908660889, 32.0, 22.0 ],
                    "text": "print"
                }
            },
            {
                "box": {
                    "format": 8,
                    "id": "obj-62",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1147.8260650634766, 969.5651988983154, 429.6296639442444, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-138",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 1060.8695449829102, 686.9565086364746, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-137",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1060.8695449829102, 717.3912906646729, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-134",
                    "linecount": 2,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1182.6086730957031, 821.7391147613525, 139.0, 35.0 ],
                    "text": "/Users/zoe/mastersdata/to_be_sorted/"
                }
            },
            {
                "box": {
                    "id": "obj-55",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 1130.4347610473633, 691.3043346405029, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-56",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1130.4347610473633, 713.0434646606445, 231.0, 22.0 ],
                    "text": "set /Users/zoe/mastersdata/to_be_sorted/"
                }
            },
            {
                "box": {
                    "id": "obj-118",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1182.6086730957031, 934.7825908660889, 57.0, 22.0 ],
                    "text": "tosymbol"
                }
            },
            {
                "box": {
                    "id": "obj-65",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 1182.6086730957031, 899.9999828338623, 174.0, 22.0 ],
                    "text": "combine 0 0 .csv @triggers 1 2"
                }
            },
            {
                "box": {
                    "id": "obj-66",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1204.3478031158447, 756.5217247009277, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-67",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "patching_rect": [ 1204.3478031158447, 782.6086807250977, 90.0, 22.0 ],
                    "text": "opendialog fold"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-76",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 904.3478088378906, 821.7391147613525, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "format": 8,
                    "id": "obj-94",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1339.1304092407227, 821.7391147613525, 103.63635993003845, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-86",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1108.6956310272217, 278.2608642578125, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "format": 8,
                    "id": "obj-88",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 943.4782428741455, 147.8260841369629, 242.39129972457886, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-93",
                    "maxclass": "newobj",
                    "numinlets": 5,
                    "numoutlets": 4,
                    "outlettype": [ "int", "", "", "int" ],
                    "patching_rect": [ 1330.434757232666, 604.3478145599365, 102.0, 22.0 ],
                    "text": "counter 1 100000"
                }
            },
            {
                "box": {
                    "id": "obj-97",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1069.5651969909668, 756.5217247009277, 32.0, 22.0 ],
                    "text": "date"
                }
            },
            {
                "box": {
                    "id": "obj-101",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 917.3912868499756, 795.6521587371826, 35.0, 22.0 ],
                    "text": "clear"
                }
            },
            {
                "box": {
                    "id": "obj-116",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "bang", "" ],
                    "patching_rect": [ 956.5217208862305, 704.3478126525879, 44.0, 22.0 ],
                    "text": "sel 1 0"
                }
            },
            {
                "box": {
                    "id": "obj-125",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "int", "int", "int" ],
                    "patching_rect": [ 1013.0434589385986, 821.7391147613525, 77.0, 22.0 ],
                    "text": "unpack 0 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-129",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "list", "list", "int" ],
                    "patching_rect": [ 1069.5651969909668, 782.6086807250977, 40.0, 22.0 ],
                    "text": "date"
                }
            },
            {
                "box": {
                    "id": "obj-131",
                    "maxclass": "gswitch2",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1286.9564971923828, 673.9130306243896, 39.0, 32.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-133",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 4,
                    "outlettype": [ "", "", "", "" ],
                    "patching_rect": [ 1308.6956272125244, 1030.434762954712, 73.0, 22.0 ],
                    "saved_object_attributes": {
                        "embed": 0,
                        "precision": 6
                    },
                    "text": "coll rawdata"
                }
            },
            {
                "box": {
                    "id": "obj-136",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 952.1738948822021, 860.8695487976074, 247.0, 22.0 ],
                    "text": "sprintf calibration-%ld-%ld-%ld--%ld-%ld-%ld"
                }
            },
            {
                "box": {
                    "id": "obj-141",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1443.4782333374023, 604.3478145599365, 143.18181681632996, 22.0 ],
                    "text": "join 6 @triggers 0"
                }
            },
            {
                "box": {
                    "id": "obj-142",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 491.3043384552002, 891.3043308258057, 47.0, 22.0 ],
                    "text": "clocker"
                }
            },
            {
                "box": {
                    "id": "obj-146",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1191.3043251037598, 439.13042640686035, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1660.8695335388184, 339.1666566133499, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1023.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-150",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 913.0434608459473, 439.13042640686035, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1327.1738877296448, 339.1666566133499, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1023.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-174",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1830.4347476959229, 439.13042640686035, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 695.7407184243202, 339.4444338083267, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1023.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-176",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "int", "int" ],
                    "patching_rect": [ 1752.173879623413, 386.9565143585205, 67.0, 22.0 ],
                    "text": "unpack 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-184",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1495.6521453857422, 439.13042640686035, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 361.66665530204773, 339.4444338083267, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1023.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-187",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 991.304328918457, 217.39130020141602, 71.0, 22.0 ],
                    "text": "fromsymbol"
                }
            },
            {
                "box": {
                    "id": "obj-188",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [ "", "", "" ],
                    "patching_rect": [ 899.9999828338623, 191.3043441772461, 82.0, 22.0 ],
                    "text": "route left right"
                }
            },
            {
                "box": {
                    "id": "obj-189",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 899.9999828338623, 217.39130020141602, 71.0, 22.0 ],
                    "text": "fromsymbol"
                }
            },
            {
                "box": {
                    "id": "obj-197",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 926.0869388580322, 117.39130210876465, 109.72222745418549, 20.0 ],
                    "text": "Initialisation patch!"
                }
            },
            {
                "box": {
                    "id": "obj-198",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
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
                        "rect": [ 59.0, 114.0, 1000.0, 690.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-46",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 213.0, 285.0, 291.0, 20.0 ],
                                    "text": "incase both micro controllers are on, only work with L"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-29",
                                    "linecount": 3,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 285.0, 100.0, 150.0, 47.0 ],
                                    "text": "Using the same insole_ble.js file as in section 2!"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-12",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 285.0, 150.0, 150.0, 33.0 ],
                                    "text": "Initially working with \"L\" microcontroller!"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 137.0, 192.5, 63.0, 22.0 ],
                                    "text": "script stop"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-39",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 58.0, 192.5, 64.0, 22.0 ],
                                    "text": "script start"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 188.0, 325.0, 150.0, 20.0 ],
                                    "text": "String -> number"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-10",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 317.0, 192.5, 150.0, 33.0 ],
                                    "text": "Library that talks with bluetooth"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 50.0, 125.0, 157.0, 22.0 ],
                                    "text": "script npm install noble-mac"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-6",
                                    "linecount": 2,
                                    "maxclass": "comment",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 240.0, 243.31999999999994, 150.0, 33.0 ],
                                    "text": "Control a local node.js script through max"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 85.91000000000003, 248.82, 137.0, 22.0 ],
                                    "saved_object_attributes": {
                                        "autostart": 0,
                                        "defer": 0,
                                        "watch": 0
                                    },
                                    "text": "node.script insole_ble.js",
                                    "textfile": {
                                        "filename": "insole_ble.js",
                                        "flags": 0,
                                        "embed": 0,
                                        "autowatch": 1
                                    }
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-67",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 58.0, 40.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-68",
                                    "index": 2,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 137.0, 40.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-69",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 85.91000000000003, 309.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "source": [ "obj-39", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-69", 0 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-39", 0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-68", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "order": 0,
                                    "source": [ "obj-8", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-39", 0 ],
                                    "order": 1,
                                    "source": [ "obj-8", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 899.9999828338623, 117.39130210876465, 18.749998211860657, 22.0 ],
                    "text": "p"
                }
            },
            {
                "box": {
                    "id": "obj-202",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1265.2173671722412, 413.04347038269043, 96.0, 20.0 ],
                    "text": "TOE AND HEEL"
                }
            },
            {
                "box": {
                    "id": "obj-203",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1013.0434589385986, 413.04347038269043, 40.66666787862778, 20.0 ],
                    "text": "HEEL"
                }
            },
            {
                "box": {
                    "id": "obj-209",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "int", "int" ],
                    "patching_rect": [ 1139.13041305542, 386.9565143585205, 67.0, 22.0 ],
                    "text": "unpack 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-210",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1139.13041305542, 343.4782543182373, 75.29412078857422, 20.0 ],
                    "text": "LEFT FOOT"
                }
            },
            {
                "box": {
                    "id": "obj-215",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "bang", "" ],
                    "patching_rect": [ 539.1304244995117, 891.3043308258057, 44.0, 22.0 ],
                    "text": "sel 1 0"
                }
            },
            {
                "box": {
                    "id": "obj-216",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 491.3043384552002, 743.4782466888428, 24.0, 24.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1099.1780224144459, 431.5217308998108, 47.727272272109985, 47.727272272109985 ]
                }
            },
            {
                "box": {
                    "id": "obj-7",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4900.00061917305, 2466.6669783592224, 100.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-77",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3402.0, 3944.0, 150.0, 20.0 ],
                    "text": "hehe"
                }
            },
            {
                "box": {
                    "id": "obj-75",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 552.1739025115967, 256.5217342376709, 119.49152827262878, 33.0 ],
                    "text": "must be on to convert nums to sigs"
                }
            },
            {
                "box": {
                    "id": "obj-73",
                    "maxclass": "ezdac~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 499.99999046325684, 247.82608222961426, 45.0, 45.0 ]
                }
            },
            {
                "box": {
                    "angle": 270.0,
                    "bgcolor": [ 0.650980392156863, 0.650980392156863, 0.650980392156863, 0.247058823529412 ],
                    "id": "obj-236",
                    "maxclass": "panel",
                    "mode": 0,
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 865.2173748016357, 647.8260746002197, 722.7272468805313, 422.72725760936737 ],
                    "proportion": 0.39,
                    "saved_attribute_attributes": {
                        "bgfillcolor": {
                            "expression": "themecolor.live_spectrum_grid_lines"
                        }
                    }
                }
            },
            {
                "box": {
                    "angle": 270.0,
                    "bgcolor": [ 0.650980392156863, 0.650980392156863, 0.650980392156863, 0.247058823529412 ],
                    "id": "obj-282",
                    "maxclass": "panel",
                    "mode": 0,
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1733.3334159851074, 1272.2222828865051, 355.67008316516876, 142.62419247627258 ],
                    "proportion": 0.39,
                    "saved_attribute_attributes": {
                        "bgfillcolor": {
                            "expression": "themecolor.live_spectrum_grid_lines"
                        }
                    }
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [ "obj-14", 1 ],
                    "midpoints": [ 539.9347724914551, 807.643603139557, 670.3260746002197, 807.643603139557 ],
                    "source": [ "obj-10", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-103", 0 ],
                    "source": [ "obj-100", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-133", 0 ],
                    "midpoints": [ 926.8912868499756, 819.5342279672623, 886.7568414211273, 819.5342279672623, 886.7568414211273, 1017.5342279672623, 1174.7568414211273, 1017.5342279672623, 1174.7568414211273, 1032.5342279672623, 1291.7568414211273, 1032.5342279672623, 1291.7568414211273, 1026.5342279672623, 1318.1956272125244, 1026.5342279672623 ],
                    "order": 0,
                    "source": [ "obj-101", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-139", 0 ],
                    "midpoints": [ 926.8912868499756, 814.6136394739151, 964.0249688625336, 814.6136394739151, 964.0249688625336, 787.6136394739151, 974.7173728942871, 787.6136394739151 ],
                    "order": 1,
                    "source": [ "obj-101", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10", 0 ],
                    "source": [ "obj-103", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-144", 1 ],
                    "source": [ "obj-11", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-138", 0 ],
                    "midpoints": [ 978.5217208862305, 727.6136394739151, 1048.0249688625336, 727.6136394739151, 1048.0249688625336, 679.6136394739151, 1070.3695449829102, 679.6136394739151 ],
                    "source": [ "obj-116", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-40", 0 ],
                    "source": [ "obj-116", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-52", 0 ],
                    "order": 0,
                    "source": [ "obj-118", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-62", 0 ],
                    "midpoints": [ 1192.1086730957031, 960.5342279672623, 1157.3260650634766, 960.5342279672623 ],
                    "order": 1,
                    "source": [ "obj-118", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-144", 0 ],
                    "source": [ "obj-12", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-136", 5 ],
                    "midpoints": [ 1158.8043270111084, 856.6136394739151, 1189.6738948822021, 856.6136394739151 ],
                    "source": [ "obj-120", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-136", 4 ],
                    "midpoints": [ 1129.8043270111084, 858.5342279672623, 1144.0738948822022, 858.5342279672623 ],
                    "source": [ "obj-120", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-136", 3 ],
                    "midpoints": [ 1100.8043270111084, 849.5342279672623, 1098.473894882202, 849.5342279672623 ],
                    "source": [ "obj-120", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-136", 2 ],
                    "midpoints": [ 1080.5434589385986, 849.5342279672623, 1052.8738948822022, 849.5342279672623 ],
                    "source": [ "obj-125", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-136", 0 ],
                    "midpoints": [ 1051.5434589385986, 849.5342279672623, 961.6738948822021, 849.5342279672623 ],
                    "source": [ "obj-125", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-136", 1 ],
                    "midpoints": [ 1022.5434589385986, 849.5342279672623, 1007.2738948822022, 849.5342279672623 ],
                    "source": [ "obj-125", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-152", 5 ],
                    "midpoints": [ 1398.388955116272, 2086.645157351799, 1277.3559493273497, 2086.645157351799 ],
                    "source": [ "obj-126", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-38", 0 ],
                    "source": [ "obj-127", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-152", 6 ],
                    "midpoints": [ 1412.2778446674347, 2086.1182166957296, 1308.704906374216, 2086.1182166957296 ],
                    "source": [ "obj-128", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-125", 0 ],
                    "midpoints": [ 1079.0651969909668, 802.6136394739151, 1022.5434589385986, 802.6136394739151 ],
                    "source": [ "obj-129", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-11", 1 ],
                    "midpoints": [ 1328.9445073604584, 2173.816447019577, 1158.888943195343, 2173.816447019577 ],
                    "source": [ "obj-13", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-133", 0 ],
                    "order": 1,
                    "source": [ "obj-131", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 0 ],
                    "midpoints": [ 1316.4564971923828, 727.6136394739151, 1333.0249688625336, 727.6136394739151, 1333.0249688625336, 823.6136394739151, 1348.6304092407227, 823.6136394739151 ],
                    "order": 0,
                    "source": [ "obj-131", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-65", 0 ],
                    "source": [ "obj-134", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9", 0 ],
                    "source": [ "obj-135", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-65", 1 ],
                    "midpoints": [ 961.6738948822021, 894.5342279672623, 1269.6086730957031, 894.5342279672623 ],
                    "source": [ "obj-136", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-134", 0 ],
                    "midpoints": [ 1070.3695449829102, 745.6136394739151, 1192.1086730957031, 745.6136394739151 ],
                    "source": [ "obj-137", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-137", 0 ],
                    "midpoints": [ 1070.3695449829102, 709.312042593956, 1070.3695449829102, 709.312042593956 ],
                    "source": [ "obj-138", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-53", 0 ],
                    "midpoints": [ 1083.3695449829102, 715.312042593956, 1100.8043270111084, 715.312042593956 ],
                    "source": [ "obj-138", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-158", 0 ],
                    "order": 1,
                    "source": [ "obj-14", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-226", 0 ],
                    "midpoints": [ 657.3260746002197, 849.5342279672623, 736.7568414211273, 849.5342279672623, 736.7568414211273, 510.53422796726227, 694.7568414211273, 510.53422796726227, 694.7568414211273, 444.53422796726227, 722.5434646606445, 444.53422796726227 ],
                    "order": 0,
                    "source": [ "obj-14", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-251", 0 ],
                    "midpoints": [ 657.3260746002197, 849.5342279672623, 472.7568414211273, 849.5342279672623, 472.7568414211273, 357.53422796726227, 500.8043384552002, 357.53422796726227 ],
                    "order": 2,
                    "source": [ "obj-14", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-131", 1 ],
                    "midpoints": [ 1452.9782333374023, 657.5342279672623, 1316.4564971923828, 657.5342279672623 ],
                    "source": [ "obj-141", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-141", 1 ],
                    "midpoints": [ 500.8043384552002, 914.3187074661255, 471.36232805252075, 914.3187074661255, 471.36232805252075, 644.3187074661255, 847.5453092809767, 644.3187074661255, 847.5453092809767, 584.3187074661255, 1477.8145967006683, 584.3187074661255 ],
                    "source": [ "obj-142", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-126", 0 ],
                    "source": [ "obj-143", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-128", 0 ],
                    "source": [ "obj-143", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-152", 4 ],
                    "midpoints": [ 1388.2222864627838, 2086.338813548966, 1246.0069922804832, 2086.338813548966 ],
                    "source": [ "obj-143", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-152", 3 ],
                    "midpoints": [ 1377.7222864627838, 2085.876366325072, 1214.6580352336168, 2085.876366325072 ],
                    "source": [ "obj-143", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-152", 2 ],
                    "midpoints": [ 1367.2222864627838, 2086.288950901944, 1183.3090781867504, 2086.288950901944 ],
                    "source": [ "obj-143", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-152", 1 ],
                    "midpoints": [ 1356.7222864627838, 2086.1973465355113, 1151.960121139884, 2086.1973465355113 ],
                    "source": [ "obj-143", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-31", 0 ],
                    "source": [ "obj-143", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-60", 0 ],
                    "source": [ "obj-143", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-145", 1 ],
                    "source": [ "obj-144", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-145", 0 ],
                    "source": [ "obj-144", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-152", 0 ],
                    "source": [ "obj-147", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-135", 0 ],
                    "midpoints": [ 481.72224473953247, 1591.816447019577, 712.2778112888336, 1591.816447019577 ],
                    "order": 2,
                    "source": [ "obj-148", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-147", 0 ],
                    "midpoints": [ 481.72224473953247, 2037.887212663889, 1120.6111640930176, 2037.887212663889 ],
                    "order": 0,
                    "source": [ "obj-148", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-149", 0 ],
                    "midpoints": [ 481.72224473953247, 1899.887212663889, 1112.27783036232, 1899.887212663889 ],
                    "order": 1,
                    "source": [ "obj-148", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-153", 0 ],
                    "midpoints": [ 1219.27783036232, 1994.9600695222616, 1267.8333933353424, 1994.9600695222616 ],
                    "source": [ "obj-149", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-154", 0 ],
                    "source": [ "obj-149", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-155", 0 ],
                    "midpoints": [ 1112.27783036232, 1995.0698668146506, 1061.4029667675495, 1995.0698668146506, 1061.4029667675495, 1995.1323670800775, 1051.166716337204, 1995.1323670800775 ],
                    "source": [ "obj-149", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-12", 1 ],
                    "source": [ "obj-15", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-11", 0 ],
                    "midpoints": [ 1371.402820467949, 2173.816447019577, 1148.388943195343, 2173.816447019577 ],
                    "order": 1,
                    "source": [ "obj-152", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-12", 0 ],
                    "order": 1,
                    "source": [ "obj-152", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-13", 0 ],
                    "midpoints": [ 1371.402820467949, 2135.648292317055, 1329.4735112190247, 2135.648292317055, 1329.4735112190247, 2137.816447019577, 1328.9445073604584, 2137.816447019577 ],
                    "order": 0,
                    "source": [ "obj-152", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-15", 0 ],
                    "order": 0,
                    "source": [ "obj-152", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-147", 3 ],
                    "midpoints": [ 1267.8333933353424, 2040.1762861311436, 1188.6111640930176, 2040.1762861311436 ],
                    "source": [ "obj-153", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-147", 2 ],
                    "midpoints": [ 1165.0556106567383, 2040.1762861311436, 1165.9444974263508, 2040.1762861311436 ],
                    "source": [ "obj-154", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-147", 1 ],
                    "source": [ "obj-155", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-143", 0 ],
                    "midpoints": [ 1220.6111688613892, 1910.270094856969, 1356.7222864627838, 1910.270094856969 ],
                    "order": 0,
                    "source": [ "obj-156", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-149", 1 ],
                    "order": 1,
                    "source": [ "obj-156", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-156", 4 ],
                    "midpoints": [ 1291.5000584125519, 1870.077571274247, 1333.6111688613892, 1870.077571274247 ],
                    "source": [ "obj-157", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-156", 3 ],
                    "midpoints": [ 1277.2500584125519, 1872.887212663889, 1305.3611688613892, 1872.887212663889 ],
                    "source": [ "obj-157", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-156", 2 ],
                    "midpoints": [ 1263.0000584125519, 1869.887212663889, 1277.1111688613892, 1869.887212663889 ],
                    "source": [ "obj-157", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-156", 1 ],
                    "midpoints": [ 1248.7500584125519, 1863.887212663889, 1248.8611688613892, 1863.887212663889 ],
                    "source": [ "obj-157", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-162", 0 ],
                    "source": [ "obj-161", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-163", 0 ],
                    "source": [ "obj-162", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-141", 5 ],
                    "midpoints": [ 1809.673879623413, 555.0341420911718, 1612.7568414211273, 555.0341420911718, 1612.7568414211273, 576.5342279672623, 1577.1600501537323, 576.5342279672623 ],
                    "order": 2,
                    "source": [ "obj-176", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-141", 4 ],
                    "midpoints": [ 1761.673879623413, 555.5342279672623, 1612.7568414211273, 555.5342279672623, 1612.7568414211273, 576.5342279672623, 1552.3236867904664, 576.5342279672623 ],
                    "order": 1,
                    "source": [ "obj-176", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-174", 0 ],
                    "order": 1,
                    "source": [ "obj-176", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-184", 0 ],
                    "midpoints": [ 1761.673879623413, 408.53422796726227, 1645.7568414211273, 408.53422796726227, 1645.7568414211273, 399.53422796726227, 1505.1521453857422, 399.53422796726227 ],
                    "order": 2,
                    "source": [ "obj-176", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-460", 0 ],
                    "order": 0,
                    "source": [ "obj-176", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-462", 0 ],
                    "order": 0,
                    "source": [ "obj-176", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-176", 0 ],
                    "midpoints": [ 1000.804328918457, 378.57783257961273, 1761.673879623413, 378.57783257961273 ],
                    "order": 0,
                    "source": [ "obj-187", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-86", 0 ],
                    "midpoints": [ 1000.804328918457, 264.57783257961273, 1118.1956310272217, 264.57783257961273 ],
                    "order": 1,
                    "source": [ "obj-187", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-187", 0 ],
                    "midpoints": [ 940.9999828338623, 213.57783257961273, 1000.804328918457, 213.57783257961273 ],
                    "source": [ "obj-188", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-189", 0 ],
                    "source": [ "obj-188", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-209", 0 ],
                    "midpoints": [ 909.4999828338623, 378.57783257961273, 1148.63041305542, 378.57783257961273 ],
                    "order": 0,
                    "source": [ "obj-189", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-86", 0 ],
                    "midpoints": [ 909.4999828338623, 264.57783257961273, 1118.1956310272217, 264.57783257961273 ],
                    "order": 1,
                    "source": [ "obj-189", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-188", 0 ],
                    "order": 1,
                    "source": [ "obj-198", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-88", 0 ],
                    "order": 0,
                    "source": [ "obj-198", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-141", 3 ],
                    "midpoints": [ 1196.63041305542, 411.53422796726227, 1249.7568414211273, 411.53422796726227, 1249.7568414211273, 402.53422796726227, 1477.7568414211273, 402.53422796726227, 1477.7568414211273, 576.5342279672623, 1527.4873234272004, 576.5342279672623 ],
                    "order": 0,
                    "source": [ "obj-209", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-141", 2 ],
                    "midpoints": [ 1148.63041305542, 426.53422796726227, 1174.7568414211273, 426.53422796726227, 1174.7568414211273, 576.5342279672623, 1502.6509600639342, 576.5342279672623 ],
                    "order": 0,
                    "source": [ "obj-209", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-146", 0 ],
                    "order": 1,
                    "source": [ "obj-209", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-150", 0 ],
                    "midpoints": [ 1148.63041305542, 411.53422796726227, 1063.7568414211273, 411.53422796726227, 1063.7568414211273, 402.53422796726227, 922.5434608459473, 402.53422796726227 ],
                    "order": 1,
                    "source": [ "obj-209", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-100", 0 ],
                    "midpoints": [ 548.6304244995117, 915.5342279672623, 535.7568414211273, 915.5342279672623, 535.7568414211273, 807.6393963521696, 526.7568414211273, 807.6393963521696, 526.7568414211273, 705.5342279672623, 539.9347724914551, 705.5342279672623 ],
                    "order": 1,
                    "source": [ "obj-215", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-198", 1 ],
                    "midpoints": [ 561.1304244995117, 915.5342279672623, 847.7568414211273, 915.5342279672623, 847.7568414211273, 114.53422796726227, 911.3749819397926, 114.53422796726227 ],
                    "order": 0,
                    "source": [ "obj-215", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-198", 0 ],
                    "midpoints": [ 548.6304244995117, 915.5342279672623, 847.7568414211273, 915.5342279672623, 847.7568414211273, 114.53422796726227, 907.3749819397926, 114.53422796726227 ],
                    "order": 0,
                    "source": [ "obj-215", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-48", 0 ],
                    "order": 1,
                    "source": [ "obj-215", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-116", 0 ],
                    "midpoints": [ 500.8043384552002, 807.5342279672623, 886.7568414211273, 807.5342279672623, 886.7568414211273, 702.5342279672623, 966.0217208862305, 702.5342279672623 ],
                    "order": 1,
                    "source": [ "obj-216", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-131", 0 ],
                    "midpoints": [ 500.8043384552002, 807.5342279672623, 886.7568414211273, 807.5342279672623, 886.7568414211273, 666.5342279672623, 1296.4564971923828, 666.5342279672623 ],
                    "order": 0,
                    "source": [ "obj-216", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-142", 0 ],
                    "order": 3,
                    "source": [ "obj-216", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-215", 0 ],
                    "midpoints": [ 500.8043384552002, 876.5342279672623, 548.6304244995117, 876.5342279672623 ],
                    "order": 2,
                    "source": [ "obj-216", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-224", 0 ],
                    "source": [ "obj-223", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-216", 0 ],
                    "source": [ "obj-224", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-452", 0 ],
                    "midpoints": [ 574.3159635066986, 734.7376260980964, 615.3623280525208, 734.7376260980964, 615.3623280525208, 1202.3187074661255, 617.8333623409271, 1202.3187074661255 ],
                    "source": [ "obj-224", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-14", 0 ],
                    "midpoints": [ 722.5434646606445, 657.4534895322286, 736.7568414211273, 657.4534895322286, 736.7568414211273, 806.9805422816426, 657.3260746002197, 806.9805422816426 ],
                    "order": 1,
                    "source": [ "obj-226", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-224", 1 ],
                    "order": 0,
                    "source": [ "obj-226", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-257", 0 ],
                    "source": [ "obj-239", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-244", 0 ],
                    "source": [ "obj-241", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-247", 0 ],
                    "source": [ "obj-244", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-239", 1 ],
                    "source": [ "obj-246", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-239", 0 ],
                    "source": [ "obj-247", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-246", 0 ],
                    "source": [ "obj-247", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-223", 0 ],
                    "source": [ "obj-251", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-254", 0 ],
                    "source": [ "obj-252", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-241", 0 ],
                    "source": [ "obj-254", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-131", 0 ],
                    "source": [ "obj-256", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-259", 0 ],
                    "midpoints": [ 1698.014462153117, 918.5342279672623, 1673.5119706335245, 918.5342279672623, 1673.5119706335245, 979.0345155969262, 1809.5000858306885, 979.0345155969262 ],
                    "source": [ "obj-257", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-261", 0 ],
                    "midpoints": [ 1714.8477954864502, 918.5342279672623, 1672.7568414211273, 918.5342279672623, 1672.7568414211273, 1016.1736568041379, 1809.5000858306885, 1016.1736568041379 ],
                    "source": [ "obj-257", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-263", 0 ],
                    "midpoints": [ 1731.6811288197835, 927.5342279672623, 1731.0071997613413, 927.5342279672623, 1731.0071997613413, 977.9400772047229, 1878.944533586502, 977.9400772047229 ],
                    "source": [ "obj-257", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-265", 0 ],
                    "midpoints": [ 1748.514462153117, 1017.1764181845356, 1878.944533586502, 1017.1764181845356 ],
                    "source": [ "obj-257", 8 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-267", 0 ],
                    "midpoints": [ 1765.3477954864502, 927.5342279672623, 1816.7568414211273, 927.5342279672623, 1816.7568414211273, 968.8178555114428, 1951.1667592525482, 968.8178555114428 ],
                    "source": [ "obj-257", 9 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-269", 0 ],
                    "midpoints": [ 1782.1811288197835, 927.5342279672623, 1816.7568414211273, 927.5342279672623, 1816.7568414211273, 1015.493952562334, 1951.1667592525482, 1015.493952562334 ],
                    "source": [ "obj-257", 10 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-271", 0 ],
                    "midpoints": [ 1799.014462153117, 918.5342279672623, 1885.7568414211273, 918.5342279672623, 1885.7568414211273, 981.5337526205694, 2026.166762828827, 981.5337526205694 ],
                    "source": [ "obj-257", 11 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-273", 0 ],
                    "midpoints": [ 1815.8477954864502, 918.5342279672623, 1885.7568414211273, 918.5342279672623, 1885.7568414211273, 1016.6580789762083, 2026.166762828827, 1016.6580789762083 ],
                    "source": [ "obj-257", 12 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 6 ],
                    "midpoints": [ 1809.5000858306885, 1158.0319675207138, 1786.8680245876312, 1158.0319675207138, 1786.8680245876312, 1605.0319675207138, 1858.8680245876312, 1605.0319675207138, 1858.8680245876312, 1767.0319675207138, 1749.8517270088196, 1767.0319675207138 ],
                    "source": [ "obj-259", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 7 ],
                    "midpoints": [ 1809.5000858306885, 1605.0319675207138, 1858.8680245876312, 1605.0319675207138, 1858.8680245876312, 1767.0319675207138, 1781.5770025253296, 1767.0319675207138 ],
                    "source": [ "obj-261", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 8 ],
                    "midpoints": [ 1878.944533586502, 1158.0319675207138, 1861.8680245876312, 1158.0319675207138, 1861.8680245876312, 1551.0319675207138, 1849.8680245876312, 1551.0319675207138, 1849.8680245876312, 1605.0319675207138, 1858.8680245876312, 1605.0319675207138, 1858.8680245876312, 1767.0319675207138, 1813.3022780418396, 1767.0319675207138 ],
                    "source": [ "obj-263", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 9 ],
                    "midpoints": [ 1878.944533586502, 1551.0319675207138, 1849.8680245876312, 1551.0319675207138, 1849.8680245876312, 1605.0319675207138, 1858.8680245876312, 1605.0319675207138, 1858.8680245876312, 1767.0319675207138, 1845.0275535583496, 1767.0319675207138 ],
                    "source": [ "obj-265", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 10 ],
                    "midpoints": [ 1951.1667592525482, 1158.0319675207138, 1930.8680245876312, 1158.0319675207138, 1930.8680245876312, 1551.0319675207138, 1939.8680245876312, 1551.0319675207138, 1939.8680245876312, 1605.0319675207138, 1876.7528290748596, 1605.0319675207138 ],
                    "source": [ "obj-267", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 11 ],
                    "midpoints": [ 1951.1667592525482, 1605.0319675207138, 1908.4781045913696, 1605.0319675207138 ],
                    "source": [ "obj-269", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 12 ],
                    "midpoints": [ 2026.166762828827, 1158.0319675207138, 2002.8680245876312, 1158.0319675207138, 2002.8680245876312, 1575.0319675207138, 1939.8680245876312, 1575.0319675207138, 1939.8680245876312, 1605.0319675207138, 1924.8680245876312, 1605.0319675207138, 1924.8680245876312, 1767.0319675207138, 1940.2033801078796, 1767.0319675207138 ],
                    "source": [ "obj-271", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 13 ],
                    "midpoints": [ 2026.166762828827, 1575.0319675207138, 1939.8680245876312, 1575.0319675207138, 1939.8680245876312, 1605.0319675207138, 1924.8680245876312, 1605.0319675207138, 1924.8680245876312, 1767.0319675207138, 1971.9286556243896, 1767.0319675207138 ],
                    "source": [ "obj-273", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-152", 8 ],
                    "midpoints": [ 1434.500067949295, 2087.0431111435173, 1371.402820467949, 2087.0431111435173 ],
                    "source": [ "obj-31", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-241", 0 ],
                    "midpoints": [ 1192.1086730957031, 1065.5342279672623, 1588.7568414211273, 1065.5342279672623, 1588.7568414211273, 672.5342279672623, 1613.8477954864502, 672.5342279672623 ],
                    "source": [ "obj-33", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-120", 0 ],
                    "midpoints": [ 1150.4347610473633, 802.6136394739151, 1100.8043270111084, 802.6136394739151 ],
                    "source": [ "obj-38", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-431", 0 ],
                    "midpoints": [ 1409.5000667572021, 1823.9088046243414, 1978.9445383548737, 1823.9088046243414 ],
                    "source": [ "obj-384", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-144", 0 ],
                    "midpoints": [ 748.3889241218567, 2206.816447019577, 1120.6111640930176, 2206.816447019577 ],
                    "source": [ "obj-4", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-101", 0 ],
                    "source": [ "obj-40", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-76", 0 ],
                    "source": [ "obj-40", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-464", 0 ],
                    "source": [ "obj-401", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-404", 0 ],
                    "source": [ "obj-403", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-406", 0 ],
                    "midpoints": [ 1828.333419561386, 1998.940383195877, 1781.722306728363, 1998.940383195877 ],
                    "source": [ "obj-404", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-420", 0 ],
                    "source": [ "obj-405", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-427", 0 ],
                    "source": [ "obj-405", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-433", 5 ],
                    "midpoints": [ 1839.722306728363, 2052.940383195877, 1869.8334112167358, 2052.940383195877 ],
                    "source": [ "obj-406", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-433", 4 ],
                    "midpoints": [ 1810.722306728363, 2054.8609716892242, 1824.4334112167357, 2054.8609716892242 ],
                    "source": [ "obj-406", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-433", 3 ],
                    "midpoints": [ 1781.722306728363, 2045.8609716892242, 1779.0334112167359, 2045.8609716892242 ],
                    "source": [ "obj-406", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-401", 0 ],
                    "order": 1,
                    "source": [ "obj-407", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-432", 0 ],
                    "midpoints": [ 1867.833421945572, 2228.8609716892242, 1969.1549571752548, 2228.8609716892242, 1969.1549571752548, 2222.8609716892242, 1995.611205816269, 2222.8609716892242 ],
                    "order": 0,
                    "source": [ "obj-407", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-403", 0 ],
                    "midpoints": [ 1778.9445288181305, 1947.940383195877, 1817.833419561386, 1947.940383195877 ],
                    "order": 0,
                    "source": [ "obj-408", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-426", 0 ],
                    "midpoints": [ 1778.9445288181305, 1941.940383195877, 1758.423084616661, 1941.940383195877, 1758.423084616661, 1947.940383195877, 1756.7223055362701, 1947.940383195877 ],
                    "order": 1,
                    "source": [ "obj-408", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-408", 0 ],
                    "midpoints": [ 1764.166749715805, 1911.638786315918, 1778.9445288181305, 1911.638786315918 ],
                    "source": [ "obj-411", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-412", 0 ],
                    "midpoints": [ 1751.166749715805, 1905.638786315918, 1751.166749715805, 1905.638786315918 ],
                    "source": [ "obj-411", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-413", 0 ],
                    "midpoints": [ 1751.166749715805, 1941.940383195877, 1867.833421945572, 1941.940383195877 ],
                    "source": [ "obj-412", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-417", 0 ],
                    "midpoints": [ 1867.833421945572, 2049.073471426964, 1884.8045480251312, 2049.073471426964, 1884.8045480251312, 2082.920639395714, 1867.833421945572, 2082.920639395714 ],
                    "source": [ "obj-413", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-415", 0 ],
                    "source": [ "obj-414", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-413", 0 ],
                    "midpoints": [ 1817.833419561386, 1941.940383195877, 1867.833421945572, 1941.940383195877 ],
                    "source": [ "obj-415", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-407", 0 ],
                    "order": 1,
                    "source": [ "obj-416", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-410", 0 ],
                    "midpoints": [ 1867.833421945572, 2156.8609716892242, 1917.8334243297577, 2156.8609716892242 ],
                    "order": 0,
                    "source": [ "obj-416", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-409", 0 ],
                    "midpoints": [ 1867.833421945572, 2127.940383195877, 1937.2778697013855, 2127.940383195877 ],
                    "order": 0,
                    "source": [ "obj-417", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-416", 0 ],
                    "midpoints": [ 1867.833421945572, 2120.8609716892242, 1867.833421945572, 2120.8609716892242 ],
                    "order": 1,
                    "source": [ "obj-417", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-419", 0 ],
                    "source": [ "obj-418", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-413", 0 ],
                    "midpoints": [ 1895.6112010478973, 1998.940383195877, 1867.833421945572, 1998.940383195877 ],
                    "source": [ "obj-419", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-425", 2 ],
                    "midpoints": [ 1590.0556309223175, 2043.0319675207138, 1537.8680245876312, 2043.0319675207138, 1537.8680245876312, 1767.0319675207138, 1489.8889575004578, 1767.0319675207138 ],
                    "source": [ "obj-420", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-425", 0 ],
                    "midpoints": [ 1228.9445025920868, 1608.3342016935349, 1284.8482716083527, 1608.3342016935349, 1284.8482716083527, 1758.3342016935349, 1448.3889575004578, 1758.3342016935349 ],
                    "source": [ "obj-423", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 0 ],
                    "midpoints": [ 1448.3889575004578, 1814.5561623573303, 1546.9733247756958, 1814.5561623573303, 1546.9733247756958, 1778.5561623573303, 1559.5000739097595, 1778.5561623573303 ],
                    "source": [ "obj-425", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-430", 0 ],
                    "source": [ "obj-426", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-402", 0 ],
                    "midpoints": [ 1603.9445204734802, 2010.940383195877, 1641.423084616661, 2010.940383195877, 1641.423084616661, 1983.940383195877, 1651.1667449474335, 1983.940383195877 ],
                    "order": 1,
                    "source": [ "obj-427", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-432", 0 ],
                    "midpoints": [ 1603.9445204734802, 2015.8609716892242, 1564.1549571752548, 2015.8609716892242, 1564.1549571752548, 2213.8609716892242, 1852.1549571752548, 2213.8609716892242, 1852.1549571752548, 2228.8609716892242, 1969.1549571752548, 2228.8609716892242, 1969.1549571752548, 2222.8609716892242, 1995.611205816269, 2222.8609716892242 ],
                    "order": 0,
                    "source": [ "obj-427", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-405", 0 ],
                    "source": [ "obj-428", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-411", 0 ],
                    "midpoints": [ 1660.888967037201, 1923.940383195877, 1725.423084616661, 1923.940383195877, 1725.423084616661, 1875.940383195877, 1751.166749715805, 1875.940383195877 ],
                    "source": [ "obj-428", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-433", 2 ],
                    "midpoints": [ 1756.3889694213867, 2045.8609716892242, 1733.6334112167358, 2045.8609716892242 ],
                    "source": [ "obj-429", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-433", 0 ],
                    "midpoints": [ 1727.3889694213867, 2045.8609716892242, 1642.8334112167358, 2045.8609716892242 ],
                    "source": [ "obj-429", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-433", 1 ],
                    "midpoints": [ 1698.3889694213867, 2045.8609716892242, 1688.233411216736, 2045.8609716892242 ],
                    "source": [ "obj-429", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-429", 0 ],
                    "midpoints": [ 1756.7223055362701, 1998.940383195877, 1698.3889694213867, 1998.940383195877 ],
                    "source": [ "obj-430", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-421", 0 ],
                    "midpoints": [ 1998.9445383548737, 1923.940383195877, 2010.423084616661, 1923.940383195877, 2010.423084616661, 2019.940383195877, 2028.9445407390594, 2019.940383195877 ],
                    "order": 0,
                    "source": [ "obj-431", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-432", 0 ],
                    "order": 1,
                    "source": [ "obj-431", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-417", 1 ],
                    "midpoints": [ 1642.8334112167358, 2090.8609716892242, 1945.333421945572, 2090.8609716892242 ],
                    "source": [ "obj-433", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-157", 0 ],
                    "midpoints": [ 1559.5000739097595, 1824.0319675207138, 1234.5000584125519, 1824.0319675207138 ],
                    "order": 1,
                    "source": [ "obj-434", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-431", 1 ],
                    "midpoints": [ 1559.5000739097595, 1824.0222970088944, 1998.9445383548737, 1824.0222970088944 ],
                    "order": 0,
                    "source": [ "obj-434", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 1 ],
                    "midpoints": [ 617.8333623409271, 1507.816447019577, 1591.2253494262695, 1507.816447019577 ],
                    "source": [ "obj-435", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 5 ],
                    "midpoints": [ 1921.388977766037, 1736.8341158174444, 1722.8482716083527, 1736.8341158174444, 1722.8482716083527, 1758.3342016935349, 1718.1264514923096, 1758.3342016935349 ],
                    "order": 1,
                    "source": [ "obj-440", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 4 ],
                    "midpoints": [ 1873.388977766037, 1737.3342016935349, 1722.8482716083527, 1737.3342016935349, 1722.8482716083527, 1758.3342016935349, 1686.4011759757996, 1758.3342016935349 ],
                    "order": 0,
                    "source": [ "obj-440", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-439", 0 ],
                    "order": 0,
                    "source": [ "obj-440", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-441", 0 ],
                    "midpoints": [ 1873.388977766037, 1590.3342016935349, 1755.8482716083527, 1590.3342016935349, 1755.8482716083527, 1581.3342016935349, 1617.833410024643, 1581.3342016935349 ],
                    "order": 1,
                    "source": [ "obj-440", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-423", 0 ],
                    "midpoints": [ 1112.27783036232, 1446.3778063058853, 1228.9445025920868, 1446.3778063058853 ],
                    "order": 1,
                    "source": [ "obj-442", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-440", 0 ],
                    "midpoints": [ 1112.27783036232, 1560.3778063058853, 1873.388977766037, 1560.3778063058853 ],
                    "order": 0,
                    "source": [ "obj-442", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-442", 0 ],
                    "midpoints": [ 1052.111159324646, 1395.3778063058853, 1112.27783036232, 1395.3778063058853 ],
                    "source": [ "obj-443", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-444", 0 ],
                    "source": [ "obj-443", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-423", 0 ],
                    "midpoints": [ 1020.611159324646, 1446.3778063058853, 1228.9445025920868, 1446.3778063058853 ],
                    "order": 1,
                    "source": [ "obj-444", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-449", 0 ],
                    "midpoints": [ 1020.611159324646, 1560.3778063058853, 1259.5000596046448, 1560.3778063058853 ],
                    "order": 0,
                    "source": [ "obj-444", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-424", 0 ],
                    "order": 0,
                    "source": [ "obj-446", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-443", 0 ],
                    "order": 1,
                    "source": [ "obj-446", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-161", 0 ],
                    "midpoints": [ 1307.5000596046448, 1593.0319675207138, 1360.8680245876312, 1593.0319675207138, 1360.8680245876312, 1581.0319675207138, 1588.8680245876312, 1581.0319675207138, 1588.8680245876312, 1728.0319675207138, 1617.833410024643, 1728.0319675207138 ],
                    "order": 1,
                    "source": [ "obj-449", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 3 ],
                    "midpoints": [ 1307.5000596046448, 1593.3342016935349, 1359.8482716083527, 1593.3342016935349, 1359.8482716083527, 1584.3342016935349, 1587.8482716083527, 1584.3342016935349, 1587.8482716083527, 1758.3342016935349, 1654.6759004592896, 1758.3342016935349 ],
                    "order": 0,
                    "source": [ "obj-449", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 2 ],
                    "midpoints": [ 1259.5000596046448, 1608.3342016935349, 1284.8482716083527, 1608.3342016935349, 1284.8482716083527, 1758.3342016935349, 1622.9506249427795, 1758.3342016935349 ],
                    "order": 0,
                    "source": [ "obj-449", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-436", 0 ],
                    "order": 2,
                    "source": [ "obj-449", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-437", 0 ],
                    "midpoints": [ 1259.5000596046448, 1593.3342016935349, 1173.8482716083527, 1593.3342016935349, 1173.8482716083527, 1584.3342016935349, 1034.5000488758087, 1584.3342016935349 ],
                    "order": 1,
                    "source": [ "obj-449", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-446", 1 ],
                    "midpoints": [ 680.3333647251129, 1483.816447019577, 996.4735112190247, 1483.816447019577, 996.4735112190247, 1279.816447019577, 1035.211159825325, 1279.816447019577 ],
                    "source": [ "obj-451", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-446", 0 ],
                    "midpoints": [ 667.8333647251129, 1483.816447019577, 996.4735112190247, 1483.816447019577, 996.4735112190247, 1288.816447019577, 1020.611159324646, 1288.816447019577 ],
                    "source": [ "obj-451", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-428", 0 ],
                    "midpoints": [ 617.8333623409271, 1435.816447019577, 1008.4735112190247, 1435.816447019577, 1008.4735112190247, 1822.816447019577, 1648.388967037201, 1822.816447019577 ],
                    "order": 1,
                    "source": [ "obj-452", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-431", 0 ],
                    "midpoints": [ 617.8333623409271, 1435.816447019577, 1008.4735112190247, 1435.816447019577, 1008.4735112190247, 1822.816447019577, 1978.9445383548737, 1822.816447019577 ],
                    "order": 0,
                    "source": [ "obj-452", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-435", 0 ],
                    "midpoints": [ 617.8333623409271, 1389.0320094823837, 617.8333623409271, 1389.0320094823837 ],
                    "order": 3,
                    "source": [ "obj-452", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-451", 0 ],
                    "midpoints": [ 617.8333623409271, 1414.6315945386887, 667.8333647251129, 1414.6315945386887 ],
                    "order": 2,
                    "source": [ "obj-452", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-464", 0 ],
                    "source": [ "obj-466", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-466", 0 ],
                    "source": [ "obj-467", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-241", 0 ],
                    "midpoints": [ 561.6739025115967, 951.5342279672623, 847.7568414211273, 951.5342279672623, 847.7568414211273, 636.5342279672623, 1594.7568414211273, 636.5342279672623, 1594.7568414211273, 705.5342279672623, 1613.8477954864502, 705.5342279672623 ],
                    "source": [ "obj-48", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-144", 0 ],
                    "midpoints": [ 712.2778112888336, 2206.816447019577, 1120.6111640930176, 2206.816447019577 ],
                    "source": [ "obj-5", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-133", 0 ],
                    "midpoints": [ 1192.1086730957031, 1032.5342279672623, 1291.7568414211273, 1032.5342279672623, 1291.7568414211273, 1026.5342279672623, 1318.1956272125244, 1026.5342279672623 ],
                    "order": 0,
                    "source": [ "obj-52", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-33", 0 ],
                    "order": 1,
                    "source": [ "obj-52", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-127", 0 ],
                    "midpoints": [ 1100.8043270111084, 751.6136394739151, 1139.9347610473633, 751.6136394739151 ],
                    "order": 0,
                    "source": [ "obj-53", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-97", 0 ],
                    "midpoints": [ 1100.8043270111084, 745.6136394739151, 1081.0249688625336, 745.6136394739151, 1081.0249688625336, 751.6136394739151, 1079.0651969909668, 751.6136394739151 ],
                    "order": 1,
                    "source": [ "obj-53", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-56", 0 ],
                    "source": [ "obj-55", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-134", 0 ],
                    "midpoints": [ 1139.9347610473633, 745.6136394739151, 1192.1086730957031, 745.6136394739151 ],
                    "source": [ "obj-56", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4", 0 ],
                    "source": [ "obj-6", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-152", 7 ],
                    "midpoints": [ 1420.6111783981323, 2086.114552296174, 1340.0538634210825, 2086.114552296174 ],
                    "source": [ "obj-60", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-118", 0 ],
                    "midpoints": [ 1192.1086730957031, 924.5342279672623, 1192.1086730957031, 924.5342279672623 ],
                    "order": 1,
                    "source": [ "obj-65", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-54", 0 ],
                    "midpoints": [ 1192.1086730957031, 931.6136394739151, 1252.9782371520996, 931.6136394739151 ],
                    "order": 0,
                    "source": [ "obj-65", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-67", 0 ],
                    "source": [ "obj-66", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-134", 0 ],
                    "midpoints": [ 1213.8478031158447, 802.6136394739151, 1192.1086730957031, 802.6136394739151 ],
                    "source": [ "obj-67", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-93", 2 ],
                    "midpoints": [ 913.8478088378906, 849.5342279672623, 886.7568414211273, 849.5342279672623, 886.7568414211273, 576.5342279672623, 1381.434757232666, 576.5342279672623 ],
                    "source": [ "obj-76", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5", 0 ],
                    "source": [ "obj-8", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-93", 0 ],
                    "midpoints": [ 1118.1956310272217, 426.53422796726227, 1174.7568414211273, 426.53422796726227, 1174.7568414211273, 576.5342279672623, 1339.934757232666, 576.5342279672623 ],
                    "source": [ "obj-86", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 0 ],
                    "midpoints": [ 727.2778112888336, 1674.115522325039, 748.3889241218567, 1674.115522325039 ],
                    "source": [ "obj-9", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-8", 0 ],
                    "source": [ "obj-9", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-141", 0 ],
                    "midpoints": [ 1339.934757232666, 632.7561886310577, 1436.8818945884705, 632.7561886310577, 1436.8818945884705, 596.7561886310577, 1452.9782333374023, 596.7561886310577 ],
                    "source": [ "obj-93", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-129", 0 ],
                    "source": [ "obj-97", 0 ]
                }
            }
        ],
        "parameters": {
            "obj-144": [ "live.gain~[1]", "live.gain~", 0 ],
            "obj-148": [ "live.tab[2]", "live.tab", 0 ],
            "obj-223": [ "live.tab[1]", "live.tab", 0 ],
            "parameterbanks": {
                "0": {
                    "index": 0,
                    "name": "",
                    "parameters": [ "-", "-", "-", "-", "-", "-", "-", "-" ],
                    "buttons": [ "-", "-", "-", "-", "-", "-", "-", "-" ]
                }
            },
            "inherited_shortname": 1
        },
        "autosave": 0,
        "oscreceiveudpport": 0
    }
}