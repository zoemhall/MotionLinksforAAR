{
    "patcher": {
        "fileversion": 1,
        "appversion": {
            "major": 9,
            "minor": 1,
            "revision": 3,
            "architecture": "x64",
            "modernui": 1
        },
        "classnamespace": "box",
        "rect": [ 34.0, 95.0, 1011.0, 765.0 ],
        "boxes": [
            {
                "box": {
                    "id": "obj-112",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 146.14, 712.2092768549919, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-103",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 146.14, 683.43, 74.0, 22.0 ],
                    "text": "delay 10000"
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
                    "patching_rect": [ 146.14, 648.8371860980988, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-98",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 1234.02, 1202.24, 84.0, 22.0 ],
                    "text": "combine 1 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-84",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1041.0256515741348, 1295.7265088558197, 24.0, 24.0 ]
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
                    "patching_rect": [ 822.0, 1008.4593920707703, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-127",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 981.9671850204468, 973.45, 31.0, 22.0 ],
                    "text": "time"
                }
            },
            {
                "box": {
                    "id": "obj-124",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "list", "list", "int" ],
                    "patching_rect": [ 981.9671850204468, 995.9016108512878, 40.0, 22.0 ],
                    "text": "date"
                }
            },
            {
                "box": {
                    "id": "obj-121",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 759.34, 973.45, 32.0, 22.0 ],
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
                    "patching_rect": [ 948.1781178712845, 1039.7724942564964, 77.0, 22.0 ],
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
                    "patching_rect": [ 1059.65, 1269.3333711624146, 81.0, 22.0 ],
                    "text": "prepend write"
                }
            },
            {
                "box": {
                    "id": "obj-108",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 808.9897878170013, 1124.0, 32.0, 22.0 ],
                    "text": "print"
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
                    "patching_rect": [ 944.112236648798, 937.6000139713287, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-95",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1064.0000158548355, 1153.6000171899796, 32.0, 22.0 ],
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
                    "patching_rect": [ 1084.482815504074, 1241.25, 337.9310522079468, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-138",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 918.1122362613678, 902.4000134468079, 32.0, 22.0 ],
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
                    "patching_rect": [ 918.1122362613678, 937.6000139713287, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-135",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1054.4000157117844, 1079.56841224432, 32.0, 22.0 ],
                    "text": "print"
                }
            },
            {
                "box": {
                    "id": "obj-134",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1035.6000154316425, 1039.7724942564964, 139.0, 22.0 ],
                    "text": "/Users/zoe/mastersdata/"
                }
            },
            {
                "box": {
                    "id": "obj-132",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 48.91, 1122.131115436554, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-130",
                    "linecount": 2,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 49.18032646179199, 1211.475375175476, 484.4262156486511, 35.0 ],
                    "text": "\"Macintosh HD:/Users/zoe/Library/CloudStorage/OneDrive-Personal/University/year 4 2/Masters/Storing data/\""
                }
            },
            {
                "box": {
                    "id": "obj-128",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 48.91, 1183.606523513794, 41.0, 22.0 ],
                    "text": "set $1"
                }
            },
            {
                "box": {
                    "id": "obj-126",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "patching_rect": [ 48.91, 1155.36, 90.0, 22.0 ],
                    "text": "opendialog fold"
                }
            },
            {
                "box": {
                    "id": "obj-123",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 981.9671850204468, 907.3770232200623, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-122",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 981.9671850204468, 931.3770232200623, 158.0, 22.0 ],
                    "text": "set /Users/zoe/mastersdata/"
                }
            },
            {
                "box": {
                    "id": "obj-118",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1059.65, 1206.6667026281357, 57.0, 22.0 ],
                    "text": "tosymbol"
                }
            },
            {
                "box": {
                    "id": "obj-117",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1221.4117441177368, 995.9016108512878, 30.0, 22.0 ],
                    "text": ".csv"
                }
            },
            {
                "box": {
                    "id": "obj-111",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 1035.6000154316425, 1116.000016629696, 174.0, 22.0 ],
                    "text": "combine 0 0 .csv @triggers 1 2"
                }
            },
            {
                "box": {
                    "id": "obj-110",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1060.1000154316425, 972.45, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-105",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "patching_rect": [ 1060.1000154316425, 995.9016108512878, 90.0, 22.0 ],
                    "text": "opendialog fold"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-96",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 759.34, 1039.7724942564964, 50.0, 22.0 ]
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
                    "patching_rect": [ 1190.745080769062, 1054.9017471075058, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-65",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 226.5, 168.0, 32.0, 22.0 ],
                    "text": "print"
                }
            },
            {
                "box": {
                    "id": "obj-63",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 416.0, 166.0, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "format": 8,
                    "id": "obj-27",
                    "maxclass": "number",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 253.0, 36.0, 242.39129972457886, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-107",
                    "maxclass": "newobj",
                    "numinlets": 5,
                    "numoutlets": 4,
                    "outlettype": [ "int", "", "", "int" ],
                    "patching_rect": [ 1041.0, 752.0638244152069, 102.0, 22.0 ],
                    "text": "counter 1 100000"
                }
            },
            {
                "box": {
                    "id": "obj-106",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 926.0000137984753, 973.45, 32.0, 22.0 ],
                    "text": "date"
                }
            },
            {
                "box": {
                    "id": "obj-97",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 772.34, 1009.4593920707703, 35.0, 22.0 ],
                    "text": "clear"
                }
            },
            {
                "box": {
                    "id": "obj-93",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "bang", "" ],
                    "patching_rect": [ 812.0, 922.5684122443199, 44.0, 22.0 ],
                    "text": "sel 1 0"
                }
            },
            {
                "box": {
                    "id": "obj-86",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "int", "int", "int" ],
                    "patching_rect": [ 865.1122362613678, 1039.7724942564964, 77.0, 22.0 ],
                    "text": "unpack 0 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-85",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "list", "list", "int" ],
                    "patching_rect": [ 926.0000137984753, 995.9016108512878, 40.0, 22.0 ],
                    "text": "date"
                }
            },
            {
                "box": {
                    "id": "obj-81",
                    "maxclass": "gswitch2",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1140.655704498291, 889.6236953735352, 39.0, 32.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-55",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 4,
                    "outlettype": [ "", "", "", "" ],
                    "patching_rect": [ 1149.245080769062, 1339.0, 133.0, 22.0 ],
                    "saved_object_attributes": {
                        "embed": 0,
                        "precision": 6
                    },
                    "text": "coll myData @embed 0"
                }
            },
            {
                "box": {
                    "id": "obj-36",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 808.9897878170013, 1079.56841224432, 189.0, 22.0 ],
                    "text": "sprintf %ld-%ld-%ld--%ld-%ld-%ld"
                }
            },
            {
                "box": {
                    "id": "obj-28",
                    "linecount": 5,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1203.5797781944275, 889.6236953735352, 150.0, 74.0 ],
                    "text": "left foot toe, left foor heel, right foot toe, right foot heel, left foot toe lower bound, left foot toe upper bound, etc. etc. "
                }
            },
            {
                "box": {
                    "id": "obj-26",
                    "maxclass": "newobj",
                    "numinlets": 14,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1160.655704498291, 854.0983362197876, 155.5, 22.0 ],
                    "text": "join 14 @triggers 0"
                }
            },
            {
                "box": {
                    "id": "obj-25",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 11.688311576843262, 706.2765913009644, 47.0, 22.0 ],
                    "text": "clocker"
                }
            },
            {
                "box": {
                    "id": "obj-1",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 765.957441329956, 763.8297817707062, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1660.8695335388184, 477.2101322412491, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 0.5 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-6",
                    "maxclass": "live.slider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 989.3616950511932, 608.5106339454651, 39.0, 142.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1886.956485748291, 321.77535259723663, 39.0, 142.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.slider[8]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "trigger",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "valuepopup": 1,
                    "varname": "live.slider[1]"
                }
            },
            {
                "box": {
                    "id": "obj-10",
                    "maxclass": "live.slider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 742.5531861782074, 606.3829743862152, 39.0, 142.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1639.1304035186768, 321.77535259723663, 39.0, 142.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.slider[9]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "reset",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "valuepopup": 1,
                    "varname": "live.slider[2]"
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 765.957441329956, 623.4042508602142, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1660.8695335388184, 339.1666566133499, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 293.61701917648315, 763.8297817707062, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1327.1738877296448, 477.2101322412491, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 0.5 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-15",
                    "maxclass": "live.slider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 514.8936133384705, 604.2553148269653, 39.0, 142.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1552.1738834381104, 322.8623090982437, 39.0, 142.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.slider[10]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "trigger",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "valuepopup": 1,
                    "varname": "live.slider[3]"
                }
            },
            {
                "box": {
                    "id": "obj-17",
                    "maxclass": "live.slider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 268.0851044654846, 604.2553148269653, 39.0, 142.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1305.4347577095032, 322.8623090982437, 39.0, 142.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.slider[11]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "reset",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "valuepopup": 1,
                    "varname": "live.slider[8]"
                }
            },
            {
                "box": {
                    "id": "obj-23",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 287.2340404987335, 621.2765913009644, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1327.1738877296448, 339.1666566133499, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-2",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 473.3191463947296, 150.0, 32.0, 22.0 ],
                    "text": "print"
                }
            },
            {
                "box": {
                    "id": "obj-92",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1270.245080769062, 1372.0, 29.5, 22.0 ],
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
                    "patching_rect": [ 1159.245080769062, 1372.0, 29.5, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-89",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 1774.3297746181488, 994.0, 29.5, 22.0 ],
                    "text": "-0.4"
                }
            },
            {
                "box": {
                    "id": "obj-90",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "signal" ],
                    "patching_rect": [ 1763.8297746181488, 1023.4042479991913, 50.5, 22.0 ],
                    "text": "pan2"
                }
            },
            {
                "box": {
                    "id": "obj-88",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 619.1489317417145, 976.595737695694, 29.5, 22.0 ],
                    "text": "-0.4"
                }
            },
            {
                "box": {
                    "id": "obj-87",
                    "maxclass": "newobj",
                    "numinlets": 4,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "signal" ],
                    "patching_rect": [ 608.5106339454651, 1006.3829715251923, 50.5, 22.0 ],
                    "text": "pan2"
                }
            },
            {
                "box": {
                    "id": "obj-83",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1763.8297746181488, 961.7021207809448, 101.0, 22.0 ],
                    "text": "procedural_audio"
                }
            },
            {
                "box": {
                    "id": "obj-82",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ -306.5934215784073, 1443.9561145305634, 150.0, 20.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-80",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1763.8297746181488, 584.0000174045563, 95.29412162303925, 20.0 ],
                    "text": "RIGHT FOOT"
                }
            },
            {
                "box": {
                    "id": "obj-32",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1753.1914768218994, 670.2127611637115, 150.0, 33.0 ],
                    "text": "subpatch\nProcessing each zone"
                }
            },
            {
                "box": {
                    "id": "obj-33",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1527.6595635414124, 534.0425493717194, 150.0, 20.0 ],
                    "text": "blue A0"
                }
            },
            {
                "box": {
                    "id": "obj-34",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1999.9999856948853, 510.6382942199707, 150.0, 20.0 ],
                    "text": "yellow A1"
                }
            },
            {
                "box": {
                    "id": "obj-35",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 4,
                    "outlettype": [ "signal", "", "", "float" ],
                    "patching_rect": [ 1829.787220954895, 734.0425479412079, 53.0, 22.0 ],
                    "text": "sections"
                }
            },
            {
                "box": {
                    "id": "obj-39",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1968.085092306137, 544.6808471679688, 150.0, 20.0 ],
                    "text": "HEEL, range 0. - 1."
                }
            },
            {
                "box": {
                    "id": "obj-41",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1504.2553083896637, 555.3191449642181, 150.0, 20.0 ],
                    "text": "TOE, range 0.8 - 0.9"
                }
            },
            {
                "box": {
                    "id": "obj-46",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2146.808495283127, 567.0851023197174, 32.0, 22.0 ],
                    "text": "0.22"
                }
            },
            {
                "box": {
                    "id": "obj-48",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1899.999986410141, 568.0851023197174, 29.5, 22.0 ],
                    "text": "0.1"
                }
            },
            {
                "box": {
                    "id": "obj-49",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 2146.808495283127, 537.795304119587, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-54",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 1899.999986410141, 543.6808471679688, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-56",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1921.2765820026398, 751.0638244152069, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 695.7407184243202, 476.4814663529396, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-57",
                    "maxclass": "live.slider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 2146.808495283127, 597.8723361492157, 39.0, 142.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 921.6666369438171, 321.6666566133499, 39.0, 142.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.slider[4]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "trigger",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "valuepopup": 1,
                    "varname": "live.slider[4]"
                }
            },
            {
                "box": {
                    "id": "obj-58",
                    "maxclass": "live.slider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 1899.999986410141, 595.7446765899658, 39.0, 142.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 674.2592376470566, 321.6666566133499, 39.0, 142.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.slider[5]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "reset",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "valuepopup": 1,
                    "varname": "live.slider[5]"
                }
            },
            {
                "box": {
                    "id": "obj-59",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1921.2765820026398, 612.7659530639648, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 695.7407184243202, 339.4444338083267, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-60",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1968.085092306137, 568.0851023197174, 150.0, 20.0 ],
                    "text": "Threshold value!"
                }
            },
            {
                "box": {
                    "id": "obj-64",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "int", "int" ],
                    "patching_rect": [ 1770.2127532958984, 289.6551876068115, 67.0, 22.0 ],
                    "text": "unpack 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-67",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1670.2127540111542, 572.2000318169594, 32.0, 22.0 ],
                    "text": "0.22"
                }
            },
            {
                "box": {
                    "id": "obj-68",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1423.4042451381683, 568.0851023197174, 29.5, 22.0 ],
                    "text": "0.1"
                }
            },
            {
                "box": {
                    "id": "obj-69",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 1670.2127540111542, 543.6808471679688, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-73",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 1423.4042451381683, 542.6808471679688, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-74",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1448.9361598491669, 751.0638244152069, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 361.66665530204773, 476.4814663529396, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-75",
                    "maxclass": "live.slider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 1670.2127540111542, 593.6170170307159, 39.0, 142.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 587.5925738215446, 322.4073973298073, 39.0, 142.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.slider[6]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "trigger",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "valuepopup": 1,
                    "varname": "live.slider[6]"
                }
            },
            {
                "box": {
                    "id": "obj-76",
                    "maxclass": "live.slider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "float" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 1423.4042451381683, 593.6170170307159, 39.0, 142.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 340.1851745247841, 322.4073973298073, 39.0, 142.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_longname": "live.slider[7]",
                            "parameter_mmax": 1.0,
                            "parameter_modmode": 3,
                            "parameter_shortname": "reset",
                            "parameter_type": 0,
                            "parameter_unitstyle": 1
                        }
                    },
                    "valuepopup": 1,
                    "varname": "live.slider[7]"
                }
            },
            {
                "box": {
                    "id": "obj-77",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1444.6808407306671, 610.638293504715, 246.0, 107.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 361.66665530204773, 339.4444338083267, 246.0, 107.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "setstyle": 5
                }
            },
            {
                "box": {
                    "id": "obj-78",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1508.5106275081635, 578.7234001159668, 150.0, 20.0 ],
                    "text": "Threshold value!"
                }
            },
            {
                "box": {
                    "id": "obj-79",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 4,
                    "outlettype": [ "signal", "", "", "float" ],
                    "patching_rect": [ 1757.4467959403992, 734.0425479412079, 53.0, 22.0 ],
                    "text": "sections"
                }
            },
            {
                "box": {
                    "id": "obj-30",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 298.0, 108.0, 71.0, 22.0 ],
                    "text": "fromsymbol"
                }
            },
            {
                "box": {
                    "id": "obj-43",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [ "", "", "" ],
                    "patching_rect": [ 207.0, 78.0, 82.0, 22.0 ],
                    "text": "route left right"
                }
            },
            {
                "box": {
                    "id": "obj-29",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 207.0, 108.0, 71.0, 22.0 ],
                    "text": "fromsymbol"
                }
            },
            {
                "box": {
                    "id": "obj-16",
                    "linecount": 2,
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 599.9999957084656, 670.2127611637115, 150.0, 33.0 ],
                    "text": "subpatch\nProcessing each zone"
                }
            },
            {
                "box": {
                    "id": "obj-12",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 608.5106339454651, 944.6808443069458, 101.0, 22.0 ],
                    "text": "procedural_audio"
                }
            },
            {
                "box": {
                    "id": "obj-11",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1176.5957362651825, 655.3191442489624, 91.73553210496902, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1077.1738924980164, 235.86956071853638, 91.73553210496902, 20.0 ],
                    "text": "surface sounds"
                }
            },
            {
                "box": {
                    "id": "obj-9",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1234.0425443649292, 689.3616971969604, 30.920786223411596, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1134.7825870513916, 268.4782557487488, 30.920786223411596, 20.0 ],
                    "text": "soft"
                }
            },
            {
                "box": {
                    "id": "obj-8",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1176.5957362651825, 689.3616971969604, 54.545451521873474, 20.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1077.1738924980164, 268.4782557487488, 54.545451521873474, 20.0 ],
                    "text": "metallic"
                }
            },
            {
                "box": {
                    "id": "obj-4",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1236.170203924179, 719.1489310264587, 24.0, 24.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1138.0434565544128, 299.9999942779541, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-3",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 1187.2340340614319, 719.1489310264587, 24.0, 24.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1088.0434575080872, 299.9999942779541, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-72",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 298.0, 8.0, 109.72222745418549, 20.0 ],
                    "text": "Initialisation patch!"
                }
            },
            {
                "box": {
                    "id": "obj-71",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 3,
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
                    "patching_rect": [ 207.0, 7.0, 18.749998211860657, 22.0 ],
                    "text": "p"
                }
            },
            {
                "box": {
                    "id": "obj-66",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 374.4680824279785, 536.1702089309692, 150.0, 20.0 ],
                    "text": "blue A0"
                }
            },
            {
                "box": {
                    "id": "obj-61",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 842.5531854629517, 510.6382942199707, 150.0, 20.0 ],
                    "text": "yellow A1"
                }
            },
            {
                "box": {
                    "id": "obj-45",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 4,
                    "outlettype": [ "signal", "", "", "float" ],
                    "patching_rect": [ 674.4680802822113, 734.0425479412079, 53.0, 22.0 ],
                    "text": "sections"
                }
            },
            {
                "box": {
                    "id": "obj-19",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 792.9134278893471, 568.0851023197174, 170.40000253915787, 20.0 ],
                    "text": "TOE AND HEEL, range 0. - 1."
                }
            },
            {
                "box": {
                    "id": "obj-18",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 348.93616771698, 555.3191449642181, 150.0, 20.0 ],
                    "text": "HEEL, range 0 - 1"
                }
            },
            {
                "box": {
                    "id": "obj-50",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 989.3616950511932, 577.7234001159668, 32.0, 22.0 ],
                    "text": "0.22"
                }
            },
            {
                "box": {
                    "id": "obj-51",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 742.5531861782074, 567.0851023197174, 29.5, 22.0 ],
                    "text": "0.1"
                }
            },
            {
                "box": {
                    "id": "obj-52",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 989.3616950511932, 547.244123518467, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-53",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 742.5531861782074, 538.7386441230774, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-70",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 814.1732715368271, 591.7071508169174, 150.0, 20.0 ],
                    "text": "Threshold value!"
                }
            },
            {
                "box": {
                    "id": "obj-47",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "int", "int" ],
                    "patching_rect": [ 621.1683325767517, 280.2469359636307, 67.0, 22.0 ],
                    "text": "unpack 0 0"
                }
            },
            {
                "box": {
                    "id": "obj-40",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 617.0212721824646, 568.0851023197174, 75.29412078857422, 20.0 ],
                    "text": "LEFT FOOT"
                }
            },
            {
                "box": {
                    "id": "obj-42",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 514.8936133384705, 577.7234001159668, 32.0, 22.0 ],
                    "text": "0.22"
                }
            },
            {
                "box": {
                    "id": "obj-31",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 268.0851044654846, 577.7234001159668, 29.5, 22.0 ],
                    "text": "0.1"
                }
            },
            {
                "box": {
                    "id": "obj-22",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 514.8936133384705, 554.3191449642181, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-20",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 268.0851044654846, 554.3191449642181, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-38",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "bang", "" ],
                    "patching_rect": [ 106.3829779624939, 785.106377363205, 44.0, 22.0 ],
                    "text": "sel 1 0"
                }
            },
            {
                "box": {
                    "id": "obj-37",
                    "maxclass": "toggle",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 79.2682945728302, 685.3658699989319, 24.0, 24.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1099.1780224144459, 431.5217308998108, 47.727272272109985, 47.727272272109985 ]
                }
            },
            {
                "box": {
                    "fontsize": 12.0,
                    "id": "obj-5",
                    "lastchannelcount": 0,
                    "maxclass": "live.gain~",
                    "numinlets": 2,
                    "numoutlets": 5,
                    "orientation": 1,
                    "outlettype": [ "signal", "signal", "", "float", "list" ],
                    "parameter_enable": 1,
                    "patching_rect": [ 1160.245080769062, 1417.0, 129.0, 39.0 ],
                    "saved_attribute_attributes": {
                        "valueof": {
                            "parameter_initial": [ 6.0 ],
                            "parameter_initial_enable": 1,
                            "parameter_longname": "live.gain~",
                            "parameter_mmax": 6.0,
                            "parameter_mmin": -70.0,
                            "parameter_modmode": 0,
                            "parameter_shortname": "live.gain~",
                            "parameter_type": 0,
                            "parameter_unitstyle": 4
                        }
                    },
                    "showname": 0,
                    "varname": "live.gain~"
                }
            },
            {
                "box": {
                    "id": "obj-7",
                    "local": 1,
                    "maxclass": "ezdac~",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 1159.245080769062, 1488.0, 44.0, 44.0 ],
                    "prototypename": "helpfile"
                }
            },
            {
                "box": {
                    "id": "obj-21",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 355.3191463947296, 578.7234001159668, 150.0, 20.0 ],
                    "text": "Threshold value!"
                }
            },
            {
                "box": {
                    "id": "obj-44",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 4,
                    "outlettype": [ "signal", "", "", "float" ],
                    "patching_rect": [ 602.1276552677155, 734.0425479412079, 53.0, 22.0 ],
                    "text": "sections"
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [ "obj-26", 8 ],
                    "midpoints": [ 752.0531861782074, 882.0, 1125.0, 882.0, 1125.0, 840.0, 1254.155704498291, 840.0 ],
                    "order": 0,
                    "source": [ "obj-10", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-45", 1 ],
                    "midpoints": [ 752.0531861782074, 750.0, 729.0, 750.0, 729.0, 729.0, 700.9680802822113, 729.0 ],
                    "order": 1,
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
                    "destination": [ "obj-106", 0 ],
                    "midpoints": [ 953.612236648798, 963.0, 936.0, 963.0, 936.0, 969.0, 935.5000137984753, 969.0 ],
                    "order": 1,
                    "source": [ "obj-102", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-127", 0 ],
                    "midpoints": [ 953.612236648798, 969.0, 991.4671850204468, 969.0 ],
                    "order": 0,
                    "source": [ "obj-102", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-112", 0 ],
                    "source": [ "obj-103", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-134", 0 ],
                    "midpoints": [ 1069.6000154316425, 1020.0, 1045.1000154316425, 1020.0 ],
                    "source": [ "obj-105", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-85", 0 ],
                    "source": [ "obj-106", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 0 ],
                    "midpoints": [ 1050.5, 840.0, 1170.155704498291, 840.0 ],
                    "source": [ "obj-107", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-55", 0 ],
                    "midpoints": [ 1069.15, 1326.0, 1158.745080769062, 1326.0 ],
                    "order": 0,
                    "source": [ "obj-109", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-84", 0 ],
                    "order": 1,
                    "source": [ "obj-109", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-105", 0 ],
                    "source": [ "obj-110", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-118", 0 ],
                    "midpoints": [ 1045.1000154316425, 1191.0, 1069.15, 1191.0 ],
                    "order": 1,
                    "source": [ "obj-111", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-95", 0 ],
                    "midpoints": [ 1045.1000154316425, 1149.0, 1073.5000158548355, 1149.0 ],
                    "order": 0,
                    "source": [ "obj-111", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-37", 0 ],
                    "source": [ "obj-112", 0 ]
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
                    "destination": [ "obj-62", 0 ],
                    "midpoints": [ 1069.15, 1236.0, 1093.982815504074, 1236.0 ],
                    "order": 0,
                    "source": [ "obj-118", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-87", 0 ],
                    "source": [ "obj-12", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-36", 5 ],
                    "midpoints": [ 1015.6781178712845, 1074.0, 988.4897878170013, 1074.0 ],
                    "source": [ "obj-120", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-36", 4 ],
                    "midpoints": [ 986.6781178712845, 1062.0, 957.0, 1062.0, 957.0, 1074.0, 954.4897878170013, 1074.0 ],
                    "source": [ "obj-120", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-36", 3 ],
                    "midpoints": [ 957.6781178712845, 1062.0, 921.0, 1062.0, 921.0, 1074.0, 920.4897878170013, 1074.0 ],
                    "source": [ "obj-120", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-96", 0 ],
                    "source": [ "obj-121", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-97", 0 ],
                    "source": [ "obj-121", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-134", 0 ],
                    "midpoints": [ 991.4671850204468, 963.0, 1045.1000154316425, 963.0 ],
                    "source": [ "obj-122", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-122", 0 ],
                    "source": [ "obj-123", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-120", 0 ],
                    "midpoints": [ 1001.9671850204468, 1020.0, 957.6781178712845, 1020.0 ],
                    "source": [ "obj-124", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-128", 0 ],
                    "source": [ "obj-126", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-124", 0 ],
                    "source": [ "obj-127", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-130", 0 ],
                    "source": [ "obj-128", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-126", 0 ],
                    "source": [ "obj-132", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-111", 0 ],
                    "source": [ "obj-134", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-134", 0 ],
                    "midpoints": [ 927.6122362613678, 963.0, 1045.1000154316425, 963.0 ],
                    "source": [ "obj-137", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-102", 0 ],
                    "midpoints": [ 940.6122362613678, 932.6984031200409, 953.612236648798, 932.6984031200409 ],
                    "source": [ "obj-138", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-137", 0 ],
                    "midpoints": [ 927.6122362613678, 926.6984031200409, 927.6122362613678, 926.6984031200409 ],
                    "source": [ "obj-138", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 7 ],
                    "midpoints": [ 524.3936133384705, 756.0, 588.0, 756.0, 588.0, 882.0, 1125.0, 882.0, 1125.0, 840.0, 1243.655704498291, 840.0 ],
                    "order": 0,
                    "source": [ "obj-15", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-44", 2 ],
                    "midpoints": [ 524.3936133384705, 747.0, 588.0, 747.0, 588.0, 720.0, 645.6276552677155, 720.0 ],
                    "order": 1,
                    "source": [ "obj-15", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 6 ],
                    "midpoints": [ 277.5851044654846, 882.0, 1125.0, 882.0, 1125.0, 840.0, 1233.155704498291, 840.0 ],
                    "order": 0,
                    "source": [ "obj-17", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-44", 1 ],
                    "midpoints": [ 277.5851044654846, 747.0, 588.0, 747.0, 588.0, 720.0, 628.6276552677155, 720.0 ],
                    "order": 1,
                    "source": [ "obj-17", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-31", 0 ],
                    "source": [ "obj-20", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-42", 0 ],
                    "source": [ "obj-22", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 1 ],
                    "midpoints": [ 21.18831157684326, 882.0, 1125.0, 882.0, 1125.0, 840.0, 1180.655704498291, 840.0 ],
                    "source": [ "obj-25", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-81", 1 ],
                    "source": [ "obj-26", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-47", 0 ],
                    "midpoints": [ 216.5, 267.0, 630.6683325767517, 267.0 ],
                    "order": 0,
                    "source": [ "obj-29", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-63", 0 ],
                    "midpoints": [ 216.5, 153.0, 425.5, 153.0 ],
                    "order": 1,
                    "source": [ "obj-29", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-65", 0 ],
                    "midpoints": [ 216.5, 153.0, 236.0, 153.0 ],
                    "order": 2,
                    "source": [ "obj-29", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-12", 2 ],
                    "midpoints": [ 1196.7340340614319, 840.0, 1023.0, 840.0, 1023.0, 894.0, 650.810633945465, 894.0 ],
                    "order": 1,
                    "source": [ "obj-3", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-83", 2 ],
                    "midpoints": [ 1196.7340340614319, 840.0, 1434.0, 840.0, 1434.0, 948.0, 1806.1297746181488, 948.0 ],
                    "order": 0,
                    "source": [ "obj-3", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-2", 0 ],
                    "midpoints": [ 307.5, 147.0, 482.8191463947296, 147.0 ],
                    "order": 1,
                    "source": [ "obj-30", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-63", 0 ],
                    "midpoints": [ 307.5, 153.0, 425.5, 153.0 ],
                    "order": 2,
                    "source": [ "obj-30", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-64", 0 ],
                    "midpoints": [ 307.5, 267.0, 1779.7127532958984, 267.0 ],
                    "order": 0,
                    "source": [ "obj-30", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-17", 0 ],
                    "source": [ "obj-31", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-56", 0 ],
                    "midpoints": [ 1873.287220954895, 759.0, 1908.0, 759.0, 1908.0, 747.0, 1930.7765820026398, 747.0 ],
                    "source": [ "obj-35", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-59", 0 ],
                    "midpoints": [ 1850.6205542882283, 768.0, 1740.0, 768.0, 1740.0, 615.0, 1884.0, 615.0, 1884.0, 591.0, 1938.0, 591.0, 1938.0, 609.0, 1930.7765820026398, 609.0 ],
                    "source": [ "obj-35", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-83", 5 ],
                    "midpoints": [ 1861.9538876215618, 948.0, 1855.3297746181488, 948.0 ],
                    "source": [ "obj-35", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-83", 4 ],
                    "source": [ "obj-35", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-111", 1 ],
                    "source": [ "obj-36", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-25", 0 ],
                    "midpoints": [ 88.7682945728302, 777.0, 63.0, 777.0, 63.0, 738.0, 69.0, 738.0, 69.0, 693.0, 21.18831157684326, 693.0 ],
                    "order": 4,
                    "source": [ "obj-37", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-38", 0 ],
                    "order": 3,
                    "source": [ "obj-37", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "midpoints": [ 88.7682945728302, 1116.0, 984.0, 1116.0, 984.0, 1473.0, 1168.745080769062, 1473.0 ],
                    "order": 0,
                    "source": [ "obj-37", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-81", 0 ],
                    "midpoints": [ 88.7682945728302, 885.0, 1150.155704498291, 885.0 ],
                    "order": 1,
                    "source": [ "obj-37", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-93", 0 ],
                    "midpoints": [ 88.7682945728302, 909.0, 821.5, 909.0 ],
                    "order": 2,
                    "source": [ "obj-37", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-100", 0 ],
                    "order": 1,
                    "source": [ "obj-38", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-71", 1 ],
                    "midpoints": [ 128.3829779624939, 819.0, 192.0, 819.0, 192.0, 3.0, 218.37499910593033, 3.0 ],
                    "source": [ "obj-38", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-71", 0 ],
                    "midpoints": [ 115.8829779624939, 819.0, 192.0, 819.0, 192.0, 3.0, 214.37499910593033, 3.0 ],
                    "order": 0,
                    "source": [ "obj-38", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-12", 3 ],
                    "midpoints": [ 1245.670203924179, 840.0, 1023.0, 840.0, 1023.0, 894.0, 667.2106339454651, 894.0 ],
                    "order": 1,
                    "source": [ "obj-4", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-83", 3 ],
                    "midpoints": [ 1245.670203924179, 840.0, 1434.0, 840.0, 1434.0, 948.0, 1822.5297746181488, 948.0 ],
                    "order": 0,
                    "source": [ "obj-4", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-15", 0 ],
                    "source": [ "obj-42", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-29", 0 ],
                    "source": [ "obj-43", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-30", 0 ],
                    "midpoints": [ 248.0, 102.0, 307.5, 102.0 ],
                    "source": [ "obj-43", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-12", 0 ],
                    "source": [ "obj-44", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-12", 1 ],
                    "source": [ "obj-44", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-14", 0 ],
                    "midpoints": [ 645.6276552677155, 768.0, 549.0, 768.0, 549.0, 750.0, 303.11701917648315, 750.0 ],
                    "source": [ "obj-44", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23", 0 ],
                    "midpoints": [ 622.9609886010488, 759.0, 576.0, 759.0, 576.0, 501.0, 333.0, 501.0, 333.0, 591.0, 296.7340404987335, 591.0 ],
                    "source": [ "obj-44", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-1", 0 ],
                    "source": [ "obj-45", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-12", 5 ],
                    "source": [ "obj-45", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-12", 4 ],
                    "source": [ "obj-45", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-13", 0 ],
                    "midpoints": [ 695.3014136155447, 768.0, 585.0, 768.0, 585.0, 600.0, 729.0, 600.0, 729.0, 591.0, 783.0, 591.0, 783.0, 618.0, 775.457441329956, 618.0 ],
                    "source": [ "obj-45", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-57", 0 ],
                    "source": [ "obj-46", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 3 ],
                    "midpoints": [ 678.6683325767517, 495.0, 1161.0, 495.0, 1161.0, 840.0, 1201.655704498291, 840.0 ],
                    "order": 0,
                    "source": [ "obj-47", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 2 ],
                    "midpoints": [ 630.6683325767517, 495.0, 1161.0, 495.0, 1161.0, 840.0, 1191.155704498291, 840.0 ],
                    "order": 0,
                    "source": [ "obj-47", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-44", 0 ],
                    "midpoints": [ 630.6683325767517, 555.0, 585.0, 555.0, 585.0, 720.0, 611.6276552677155, 720.0 ],
                    "order": 1,
                    "source": [ "obj-47", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-45", 0 ],
                    "midpoints": [ 678.6683325767517, 555.0, 585.0, 555.0, 585.0, 720.0, 683.9680802822113, 720.0 ],
                    "order": 1,
                    "source": [ "obj-47", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-58", 0 ],
                    "source": [ "obj-48", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-46", 0 ],
                    "source": [ "obj-49", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 1 ],
                    "source": [ "obj-5", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7", 0 ],
                    "source": [ "obj-5", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 0 ],
                    "source": [ "obj-50", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10", 0 ],
                    "source": [ "obj-51", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-50", 0 ],
                    "source": [ "obj-52", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-51", 0 ],
                    "source": [ "obj-53", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-48", 0 ],
                    "source": [ "obj-54", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 13 ],
                    "midpoints": [ 2156.308495283127, 747.0, 2178.0, 747.0, 2178.0, 870.0, 1326.0, 870.0, 1326.0, 849.0, 1306.655704498291, 849.0 ],
                    "order": 1,
                    "source": [ "obj-57", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-35", 2 ],
                    "midpoints": [ 2156.308495283127, 741.0, 2133.0, 741.0, 2133.0, 735.0, 1938.0, 735.0, 1938.0, 738.0, 1884.0, 738.0, 1884.0, 729.0, 1873.287220954895, 729.0 ],
                    "order": 0,
                    "source": [ "obj-57", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 12 ],
                    "midpoints": [ 1909.499986410141, 870.0, 1326.0, 870.0, 1326.0, 840.0, 1296.155704498291, 840.0 ],
                    "order": 1,
                    "source": [ "obj-58", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-35", 1 ],
                    "midpoints": [ 1909.499986410141, 738.0, 1884.0, 738.0, 1884.0, 729.0, 1856.287220954895, 729.0 ],
                    "order": 0,
                    "source": [ "obj-58", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 9 ],
                    "midpoints": [ 998.8616950511932, 759.0, 1023.0, 759.0, 1023.0, 840.0, 1264.655704498291, 840.0 ],
                    "order": 0,
                    "source": [ "obj-6", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-45", 2 ],
                    "midpoints": [ 998.8616950511932, 753.0, 975.0, 753.0, 975.0, 747.0, 783.0, 747.0, 783.0, 750.0, 729.0, 750.0, 729.0, 729.0, 717.9680802822113, 729.0 ],
                    "order": 1,
                    "source": [ "obj-6", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-107", 0 ],
                    "midpoints": [ 425.5, 495.0, 1050.5, 495.0 ],
                    "source": [ "obj-63", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 5 ],
                    "midpoints": [ 1827.7127532958984, 501.0, 1278.0, 501.0, 1278.0, 840.0, 1222.655704498291, 840.0 ],
                    "order": 1,
                    "source": [ "obj-64", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 4 ],
                    "midpoints": [ 1779.7127532958984, 501.0, 1278.0, 501.0, 1278.0, 840.0, 1212.155704498291, 840.0 ],
                    "order": 1,
                    "source": [ "obj-64", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-35", 0 ],
                    "midpoints": [ 1827.7127532958984, 570.0, 1740.0, 570.0, 1740.0, 720.0, 1839.287220954895, 720.0 ],
                    "order": 0,
                    "source": [ "obj-64", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-79", 0 ],
                    "midpoints": [ 1779.7127532958984, 570.0, 1740.0, 570.0, 1740.0, 720.0, 1766.9467959403992, 720.0 ],
                    "order": 0,
                    "source": [ "obj-64", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-75", 0 ],
                    "source": [ "obj-67", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-76", 0 ],
                    "source": [ "obj-68", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-67", 0 ],
                    "source": [ "obj-69", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-27", 0 ],
                    "order": 0,
                    "source": [ "obj-71", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-43", 0 ],
                    "order": 1,
                    "source": [ "obj-71", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-68", 0 ],
                    "source": [ "obj-73", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 11 ],
                    "midpoints": [ 1679.7127540111542, 738.0, 1434.0, 738.0, 1434.0, 840.0, 1285.655704498291, 840.0 ],
                    "order": 1,
                    "source": [ "obj-75", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-79", 2 ],
                    "midpoints": [ 1679.7127540111542, 738.0, 1743.0, 738.0, 1743.0, 720.0, 1800.9467959403992, 720.0 ],
                    "order": 0,
                    "source": [ "obj-75", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 10 ],
                    "midpoints": [ 1432.9042451381683, 840.0, 1275.155704498291, 840.0 ],
                    "order": 1,
                    "source": [ "obj-76", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-79", 1 ],
                    "midpoints": [ 1432.9042451381683, 738.0, 1743.0, 738.0, 1743.0, 720.0, 1783.9467959403992, 720.0 ],
                    "order": 0,
                    "source": [ "obj-76", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-74", 0 ],
                    "midpoints": [ 1800.9467959403992, 768.0, 1704.0, 768.0, 1704.0, 738.0, 1458.4361598491669, 738.0 ],
                    "source": [ "obj-79", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-77", 0 ],
                    "midpoints": [ 1778.2801292737324, 759.0, 1731.0, 759.0, 1731.0, 501.0, 1488.0, 501.0, 1488.0, 597.0, 1464.0, 597.0, 1464.0, 606.0, 1454.1808407306671, 606.0 ],
                    "source": [ "obj-79", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-83", 0 ],
                    "midpoints": [ 1789.613462607066, 948.0, 1773.3297746181488, 948.0 ],
                    "source": [ "obj-79", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-83", 1 ],
                    "midpoints": [ 1766.9467959403992, 948.0, 1789.729774618149, 948.0 ],
                    "source": [ "obj-79", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-55", 0 ],
                    "order": 1,
                    "source": [ "obj-81", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 0 ],
                    "midpoints": [ 1170.155704498291, 945.0, 1188.0, 945.0, 1188.0, 1041.0, 1200.245080769062, 1041.0 ],
                    "order": 0,
                    "source": [ "obj-81", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-90", 0 ],
                    "source": [ "obj-83", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-86", 0 ],
                    "midpoints": [ 935.5000137984753, 1020.0, 874.6122362613678, 1020.0 ],
                    "source": [ "obj-85", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-36", 2 ],
                    "midpoints": [ 932.6122362613678, 1062.0, 888.0, 1062.0, 888.0, 1074.0, 886.4897878170013, 1074.0 ],
                    "source": [ "obj-86", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-36", 0 ],
                    "midpoints": [ 903.6122362613678, 1062.0, 819.0, 1062.0, 819.0, 1074.0, 818.4897878170013, 1074.0 ],
                    "source": [ "obj-86", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-36", 1 ],
                    "midpoints": [ 874.6122362613678, 1062.0, 852.4897878170013, 1062.0 ],
                    "source": [ "obj-86", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-91", 0 ],
                    "midpoints": [ 618.0106339454651, 1368.0, 1168.745080769062, 1368.0 ],
                    "source": [ "obj-87", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-92", 0 ],
                    "midpoints": [ 649.5106339454651, 1309.4702188496012, 1293.0, 1309.4702188496012, 1293.0, 1368.0, 1279.745080769062, 1368.0 ],
                    "source": [ "obj-87", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-87", 1 ],
                    "source": [ "obj-88", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-90", 1 ],
                    "source": [ "obj-89", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-91", 1 ],
                    "midpoints": [ 1773.3297746181488, 1404.0, 1200.0, 1404.0, 1200.0, 1368.0, 1179.245080769062, 1368.0 ],
                    "source": [ "obj-90", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-92", 1 ],
                    "midpoints": [ 1804.8297746181488, 1359.0, 1290.245080769062, 1359.0 ],
                    "source": [ "obj-90", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5", 0 ],
                    "source": [ "obj-91", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5", 1 ],
                    "source": [ "obj-92", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-121", 0 ],
                    "source": [ "obj-93", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-138", 0 ],
                    "midpoints": [ 834.0, 945.0, 903.0, 945.0, 903.0, 897.0, 927.6122362613678, 897.0 ],
                    "source": [ "obj-93", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-107", 2 ],
                    "midpoints": [ 768.84, 1062.0, 852.0, 1062.0, 852.0, 1026.0, 867.0, 1026.0, 867.0, 882.0, 1026.0, 882.0, 1026.0, 750.0, 1038.0, 750.0, 1038.0, 738.0, 1092.0, 738.0 ],
                    "source": [ "obj-96", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-139", 0 ],
                    "midpoints": [ 781.84, 1032.0, 819.0, 1032.0, 819.0, 1005.0, 831.5, 1005.0 ],
                    "order": 1,
                    "source": [ "obj-97", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-55", 0 ],
                    "midpoints": [ 781.84, 1032.0, 810.0, 1032.0, 810.0, 1074.0, 804.0, 1074.0, 804.0, 1116.0, 984.0, 1116.0, 984.0, 1326.0, 1158.745080769062, 1326.0 ],
                    "order": 0,
                    "source": [ "obj-97", 0 ]
                }
            }
        ],
        "parameters": {
            "obj-10": [ "live.slider[9]", "reset", 0 ],
            "obj-12::obj-26": [ "toggle[3]", "toggle", 0 ],
            "obj-12::obj-54": [ "toggle[2]", "toggle", 0 ],
            "obj-15": [ "live.slider[10]", "trigger", 0 ],
            "obj-17": [ "live.slider[11]", "reset", 0 ],
            "obj-5": [ "live.gain~", "live.gain~", 0 ],
            "obj-57": [ "live.slider[4]", "trigger", 0 ],
            "obj-58": [ "live.slider[5]", "reset", 0 ],
            "obj-6": [ "live.slider[8]", "trigger", 0 ],
            "obj-75": [ "live.slider[6]", "trigger", 0 ],
            "obj-76": [ "live.slider[7]", "reset", 0 ],
            "obj-83::obj-26": [ "toggle[5]", "toggle", 0 ],
            "obj-83::obj-54": [ "toggle[4]", "toggle", 0 ],
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