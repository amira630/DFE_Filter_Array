var lintMessages = {
    "details": [
        {
            "recid": "1",
            "severity": "Warning",
            "message": "",
            "backref": "",
            "w2ui": {
                "children": [
                    {
                        "recid": "11",
                        "information": "(1) (elaboration-835) Latch inferred in always_comb.",
                        "backref": "",
                        "w2ui": {
                            "children": [
                                {
                                    "recid": "111",
                                    "information": "Latch inferred in always_comb.  Signal 'coeff_out' in module 'TOP', File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/TOP.sv', Line 202. Possible RTL coding oversight. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Latch inferred in always_comb.  Signal 'coeff_out' in module 'TOP', File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/TOP.sv', Line 202. Possible RTL coding oversight. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/TOP.sv,202"
                                }
                            ]
                        }
                    },
                    {
                        "recid": "12",
                        "information": "(11) (parser-285) Vopt warning.",
                        "backref": "",
                        "w2ui": {
                            "children": [
                                {
                                    "recid": "121",
                                    "information": "Vopt warning.  (vopt-13314) Defaulting port 'coeff_data_in' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/fractional_decimator.sv', Line 21. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Vopt warning.  (vopt-13314) Defaulting port 'coeff_data_in' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/fractional_decimator.sv', Line 21. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/fractional_decimator.sv,21"
                                },
                                {
                                    "recid": "122",
                                    "information": "Vopt warning.  (vopt-13314) Defaulting port 'coeff_in' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir.sv', Line 24. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Vopt warning.  (vopt-13314) Defaulting port 'coeff_in' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir.sv', Line 24. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir.sv,24"
                                },
                                {
                                    "recid": "123",
                                    "information": "Vopt warning.  (vopt-13314) Defaulting port 'coeff_in_1MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir_chain.sv', Line 26. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Vopt warning.  (vopt-13314) Defaulting port 'coeff_in_1MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir_chain.sv', Line 26. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir_chain.sv,26"
                                },
                                {
                                    "recid": "124",
                                    "information": "Vopt warning.  (vopt-13314) Defaulting port 'coeff_in_2MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir_chain.sv', Line 37. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Vopt warning.  (vopt-13314) Defaulting port 'coeff_in_2MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir_chain.sv', Line 37. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir_chain.sv,37"
                                },
                                {
                                    "recid": "125",
                                    "information": "Vopt warning.  (vopt-13314) Defaulting port 'coeff_in_2_4MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir_chain.sv', Line 48. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Vopt warning.  (vopt-13314) Defaulting port 'coeff_in_2_4MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir_chain.sv', Line 48. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/iir_chain.sv,48"
                                },
                                {
                                    "recid": "126",
                                    "information": "Vopt warning.  (vopt-2685) [TFMPC] - Too few port connections for 'COMB_INST_0'.  Expected 6, found 5, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/cic.sv', Line 117. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Vopt warning.  (vopt-2685) [TFMPC] - Too few port connections for 'COMB_INST_0'.  Expected 6, found 5, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/cic.sv', Line 117. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/cic.sv,117"
                                },
                                {
                                    "recid": "127",
                                    "information": "Vopt warning.  (vopt-2718) [TFMPC] - Missing connection for port 'valid_out', File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/cic.sv', Line 117. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Vopt warning.  (vopt-2718) [TFMPC] - Missing connection for port 'valid_out', File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/cic.sv', Line 117. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/cic.sv,117"
                                },
                                {
                                    "recid": "128",
                                    "information": "Vopt warning.  (vopt-13314) Defaulting port 'frac_dec_coeff_data_in' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv', Line 36. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Vopt warning.  (vopt-13314) Defaulting port 'frac_dec_coeff_data_in' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv', Line 36. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv,36"
                                },
                                {
                                    "recid": "129",
                                    "information": "Vopt warning.  (vopt-13314) Defaulting port 'iir_coeff_in_1MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv', Line 48. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Vopt warning.  (vopt-13314) Defaulting port 'iir_coeff_in_1MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv', Line 48. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv,48"
                                },
                                {
                                    "recid": "130",
                                    "information": "Vopt warning.  (vopt-13314) Defaulting port 'iir_coeff_in_2MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv', Line 55. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Vopt warning.  (vopt-13314) Defaulting port 'iir_coeff_in_2MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv', Line 55. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv,55"
                                },
                                {
                                    "recid": "131",
                                    "information": "Vopt warning.  (vopt-13314) Defaulting port 'iir_coeff_in_2_4MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv', Line 63. Elaboration will continue.",
                                    "severity": "Warning",
                                    "message": "Vopt warning.  (vopt-13314) Defaulting port 'iir_coeff_in_2_4MHz' kind to 'var' rather than 'wire' due to default compile option setting of -svinputport=relaxed, File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv', Line 63. Elaboration will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/CORE.sv,63"
                                }
                            ]
                        }
                    },
                    {
                        "recid": "13",
                        "information": "(1) (parser-3) Too few module port connections for an instance.",
                        "backref": "",
                        "w2ui": {
                            "children": [
                                {
                                    "recid": "131",
                                    "information": "Too few module port connections for an instance.  Instance 'COMB_INST_0', Module 'COMB', File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/cic.sv', Line 117. Interface might be specified incorrectly.  Parsing will continue.",
                                    "severity": "Warning",
                                    "message": "Too few module port connections for an instance.  Instance 'COMB_INST_0', Module 'COMB', File 'D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/cic.sv', Line 117. Interface might be specified incorrectly.  Parsing will continue.",
                                    "backref": "D:\/Mustafa\/Projects\/Digital_Design\/Si_Clash_N\/Design\/DFE_Filter_Array\/System\/cic.sv,117"
                                }
                            ]
                        }
                    }
                ]
            },
            "information": "Warnings (13)"
        }
    ],
    "Status": "Passed",
    "Fatal": "0",
    "Error": "0",
    "Warning": "13",
    "Info": "0"
}
;