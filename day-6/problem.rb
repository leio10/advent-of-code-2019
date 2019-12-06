class Problem
  attr_reader :orbits

  def initialize(input)
    @orbits = input.split("\n").map {|line| line.split(")").reverse } .to_h
  end

  def count_orbits
    suns.sum { |sun| count_planet_orbits(sun, 1) }
  end

  def path_for(planet)
    [].tap do |path|
      while planet
        path << planet
        planet = orbits[planet]
      end
    end
  end

  private

  def directs
    @directs ||= Hash.new { |h,k| h[k] = [] }.tap do |ret|
      orbits.each do |orbitting, orbitted|
        ret[orbitted] << orbitting
      end
    end
  end

  def suns
    @suns ||= directs.keys - orbits.keys
  end

  def count_planet_orbits(planet, acum)
    directs[planet].sum do |orbitting|
      acum + count_planet_orbits(orbitting, acum + 1)
    end
  end
end

INPUT = "PJK)X3G\nZM3)JGN\nYYF)614\nK5T)X18\n2PT)2BR\n4RF)VL2\nQQN)7S4\nX9S)HM9\nNMG)DH5\nTQD)SJD\n2JD)SM4\n5SD)4NG\nW1R)XYJ\nDXF)72L\nCGN)T85\nZF4)ZZ1\n91Q)Y69\nSMB)QSZ\nPVN)PP3\nC4S)1VL\n3BK)ZNZ\nLYZ)92X\nTPP)XPP\nNTK)R7B\nXMH)GBQ\nLZW)49Y\n28R)R1G\n5SX)F2K\nX21)WC7\nJL7)ZKL\nF1G)XF8\nXJG)N8L\n227)HBK\nFG8)RMS\nS5B)RXD\nT71)LDZ\nTYQ)2LW\n1W2)BFQ\n2X1)NCQ\nSJL)TG5\n64W)RKB\nDRH)W45\nZTK)YC5\nL1Y)VXS\nSGD)F66\nZBG)YJ7\nNC6)544\nXKQ)8Z5\nB5K)XFW\nV3F)SF9\nDC7)737\nZCJ)ZCB\nJPX)FZS\nPFB)TYQ\nC22)HGM\nC67)MDM\n4W1)X87\nTQX)7YM\n2Y4)CLQ\nR1G)M5V\nHK5)56W\nY7B)8RN\nLFR)FN6\nRVW)7G3\nSXH)97Y\nH25)WHC\nX8Y)3H8\n97Y)77T\n6VB)91Q\nV7S)595\nJFH)2JD\nZSL)HHS\n3D6)T71\n1BP)MCR\nFBQ)2PB\n7Q9)K1X\nC81)6JF\nYYQ)9FR\nFBR)GZS\nVXK)4BR\nZ9L)DYJ\nPRL)K2Y\nQ68)R8F\nWJC)WZ5\nH3K)3NG\nK9N)BG4\nVXS)RLT\nK1Q)R29\nC76)TNL\nRLV)PCY\nZ4J)2GC\n4F2)SC2\nY82)JKM\nGZS)Q1Q\nVB3)WRW\nXW6)FK8\nYG1)73H\nKZQ)9FQ\nR25)C13\nFFZ)DTC\nH99)Y82\nN12)TRX\nF5G)RLV\n7VN)D7V\nCRJ)GY4\nC7S)YD3\nV6S)CNH\n82G)ZBV\nKMM)YOU\n27R)S8P\nZTK)2PT\n8R4)HC5\nV9D)ZSV\nL25)N12\n544)ZT7\n62H)SBL\nZMG)M4P\nY77)SB7\nG6R)2RZ\nYPB)6ZG\nWKT)FVM\n126)ZPY\n8KQ)KSF\nG3Q)W3D\n56F)RZX\nKFC)LHG\n75Y)BHL\n921)95L\nQRQ)SG4\n8BW)KGK\n5D5)YH2\n4PK)9LQ\n7J4)QQN\nF8Q)SBM\n14K)5NV\n6NP)91L\nJKM)HR1\n9G9)Q7P\nP74)BCK\nDBC)K1H\nCH7)Z9W\nGBK)YFR\nLLX)YG1\nKFB)C53\n7XJ)8Q8\n54L)JMG\n2PB)P2C\nZPY)V3S\nNG6)WNM\nR29)LN8\n1DT)LTD\nXLM)X12\n3HQ)G3Q\n95L)VM4\n8RN)Q28\n2GC)CVB\nBHL)N5T\nX9T)GBK\nJ27)G8G\nLHG)RR3\nFS5)XSF\n6HN)WC8\nWQR)G1C\nX5M)SXQ\nMCR)Q6W\nF57)7W8\nQKG)X4T\nPL8)BZM\nJM3)3KS\nGYP)6S2\n8V3)4TV\nGSV)Y9V\nJKM)5WX\nVSM)3Q5\nL7Q)L1C\nMFX)T1R\nGQ2)22M\n4L4)W3W\nTRX)45N\nGLG)WKT\n92T)KTL\n1PB)TFX\nC9N)88W\nZ19)PTB\n95K)NGQ\n8H6)CHW\nDC8)7NY\nR8F)HHP\nTFX)S9L\nP61)4JD\nKDW)GMS\n961)J5R\nC4H)35Y\nBJQ)FDN\nR79)P6J\nQTH)B6J\nK2Y)3RY\nK47)NC6\nGQR)C5W\n6HN)LLX\nQ7P)921\nWPV)VLF\n329)YPB\n3XV)RR1\nDTC)2CF\nC9K)X43\n5SB)X9T\n9ZL)8V3\nF5G)XMH\nVD5)XG2\n97R)SC9\nNCQ)F2D\nBML)2JY\nN8G)DMN\n6Y7)JXB\nM4P)Z4J\nPL1)M52\n57Z)HSB\nLP8)WXJ\nX49)ZHJ\nYQ4)LBF\nTZN)26G\n3NG)PLN\nXLC)TBR\n8ZV)77G\n3SR)QR2\n91B)J7Y\nPWH)LJS\nGG3)91S\n2NJ)C23\nMRG)V2D\n77G)NBP\nDBC)3N2\nQ1Q)Z34\nBH4)B5K\nV5P)8Q7\n35Y)39W\nDMN)DKJ\nGY4)HPQ\n66L)S4M\nFK8)W9R\nW3W)X5M\nYBW)X41\nWPG)XQN\nBKC)NBD\n82C)8ZV\n8LR)P74\nXL9)F17\nDKJ)V6X\n836)FFB\nRS8)K1Q\nCY5)4PC\nYFR)GTQ\nQF6)ZLD\n35K)5YW\nP6J)Z8W\nZ39)NJK\nJ8X)T8P\n15H)YXX\nK5M)3B4\nFVY)L93\nDS2)QP5\n39W)WTS\nNFM)LFR\n4ZR)N8K\nJGW)4XY\nXSP)9YR\n5WB)286\n292)637\nKTL)3CT\nTQR)GPW\nZT7)7H2\n6YX)VCC\nG2X)HLX\n7QT)33M\nSXQ)6VY\n1WQ)ZMG\nG1C)35K\nD7V)PZG\n73H)NG6\nTQD)6M6\nGPW)YQ4\nC67)C4H\nG6F)9YS\nYLZ)YBW\n4XZ)KSG\n11N)V9D\n56W)8R4\nS8P)PVN\nXG2)Z7K\nLBF)6KM\nZSV)VF3\nQV6)JJN\n2D9)VM8\nTYB)NTG\nQ94)QNF\n4JD)J8X\n5WB)MVZ\nX12)KV2\n79V)VP8\n8VV)B6R\nT42)8BW\nC13)Z9L\nWFY)HC7\n3LK)RV9\n6LP)W98\n6LD)XLM\nYBQ)GQ2\nVF3)MLX\nDQ7)66L\nC53)5F1\n5F1)YZY\n3GQ)C67\nM52)VWY\nM89)9L5\nHPQ)4W1\n8Z5)7FX\nF8Q)1TY\n4FC)VN3\n2DG)PL1\nKT2)7QT\nX3G)GH2\nVFH)5ZL\n3SN)ZW3\nRTP)1KS\nKGK)2NJ\n8Z5)F57\n91S)DC7\nSLY)QBX\nBKH)M89\n637)6FC\nV7K)L25\nQCF)Q3X\n4L1)X58\nB2S)J5L\nJJK)6PN\nF4V)MHH\nSC4)34G\n5XC)GPJ\nPTB)579\nC3D)XCK\nHDY)PCH\nKTM)8XY\n3KS)GYP\nHHS)RD2\n68B)YBQ\nL1C)7C7\nTKK)NWD\nYD3)JKC\nVM8)38W\nS9X)H3K\nVN3)WPG\n2RZ)56F\nPG2)Z3G\nSJD)SKH\nJKC)XJG\nKTK)V6B\nZ7L)64W\n6KS)GR6\nBZM)6NP\nHSB)2T3\nYC5)5WB\n6RL)PFB\nTL2)XSP\n8NL)VV7\nKZH)3BK\nFN6)FG8\nNQ6)YWV\n4K3)WFZ\n4VT)SZH\n7C7)JKB\nFJJ)WP9\nFBZ)QRQ\n88W)RD6\nGPH)5VZ\nF17)7FJ\nVWY)TWJ\nBRN)95K\nR55)LP8\n9K3)M4B\nNWD)JSX\n4NS)783\n6VH)D6T\nXYQ)BHN\n3RY)MFX\nKGR)QGX\n1XH)MNS\n1TY)15L\nXWV)WJC\nJJN)8B3\nY8L)Y7B\nFFQ)3SG\nF77)Z5Z\n783)Q9R\nHF2)RMK\nWRW)JT4\n6MS)FBQ\n44G)BRN\nFDN)289\n4NJ)ZF6\nWN8)Y77\n66G)FMH\n773)7HJ\nM4B)Z7L\nV88)52G\n2HR)24V\n3KH)VYY\n77T)PG2\nS8N)G6F\nQY2)54G\nF66)9KL\nFLB)SFB\nHLX)32D\nS4M)VXK\nXPP)DQ7\n3SG)BH4\nZ5S)XW6\n92X)XLC\nLQ4)3GQ\n729)PRL\nS3N)Z5S\n29B)K47\nWBQ)TKK\nBJR)GC5\nY82)ZM3\nGK1)62H\n8Q7)ZR3\n7YM)7Q9\n4R4)FQ7\nB6V)2HR\nT95)LQ4\nT99)6SL\nCOM)ZB8\n4SC)SMZ\nX87)GX6\nZKL)M72\n7W8)WN8\n64G)15F\n34G)K9J\nBSK)2MM\n1ZV)4FC\nZ5Z)CZC\nLKS)N8G\nXDC)P5D\nRXD)B9R\n2BR)BKC\nHHP)85J\nQX7)FWL\nWTS)WBQ\nZLY)6T5\nLP9)G65\n9ZL)GG2\n4JY)2FH\nQJZ)384\n6S2)ZLY\n2W1)XL9\nX4T)LKB\n38W)2YD\nRZX)NL6\n2BW)ZF4\nK6L)24D\nTZM)SGD\n2JY)K5T\nMP9)GLG\n8VV)TQX\nMQJ)G2B\nW9R)Y8L\n6Y8)8NR\nCNH)2X1\n5Y4)QKG\nTWJ)V7S\nCNJ)9K3\n5VZ)YYF\n48Q)4L1\n1VL)2W1\nHSB)VC9\nHKT)45Z\nCP6)XY1\nJKC)GM1\nB1H)D6Q\n4B9)8XW\nDLX)15H\n45Z)HNQ\n289)75Y\n2MM)GCH\nNBD)FFZ\nQGX)Q3V\nN1F)9G9\nP54)P9L\nGC5)62Z\n15L)11N\nTK1)CCW\n35W)8S3\n4NG)4FZ\n1P9)MND\n5ZL)FVY\nL5P)79V\nVCC)WPV\n8BG)9M4\n24V)T95\nYFR)F1G\nFS5)H1M\nJKB)YVS\nN1K)7NP\nLKR)S82\nSLY)7R3\nGTQ)L2N\nL2N)4DJ\nCGN)7S9\nNJ7)7QH\nWXB)KT2\nR3T)78Q\nXSF)QCF\nT85)1W2\n11N)29B\n6SL)BQ2\n1Y2)C81\nB6J)5XC\nGV4)LW1\nFFB)1WQ\nGPP)6LP\nFYL)4R4\nK9N)KZQ\nZB8)RRS\nYP6)Q68\n9FQ)1PB\n7G3)2L3\nKJK)NYV\nWNM)9ZL\nJMZ)QF6\n38S)44G\nJG6)LYZ\n286)WXS\nB4B)Y8Y\nZML)VRJ\nZ2X)FVK\nTNS)8BG\n8S3)QLD\nNBP)DRH\nTKL)429\nCC7)9DN\nFYL)14D\nLLX)3SZ\nQQX)WF9\nLJS)GMZ\n7R3)2WR\n4GT)4F2\n9LQ)DBC\nYPZ)4GT\n9BK)SMB\nQB9)P4L\n3N2)ZQ9\n7N8)F7L\nBLG)B2S\n1SF)W53\nZZ1)4B9\nH4Q)KJK\nZXN)4SC\n82C)8D8\n15F)KGR\n54G)XXH\nJ7Y)QJZ\nSNM)SXH\nBKH)8VV\nSMB)KTK\nZS2)2KV\nL2N)C76\nQ1T)BJQ\nGQR)SK6\nQQK)TGL\nLW1)FLB\n3B4)J6L\nV6B)57Z\nY1R)2DG\nQQH)Z2Q\nG8G)8KQ\n8NR)K9N\n6M6)3KH\nJ27)28R\n85J)48Q\nRLT)LKR\nXY1)CGN\nZW3)N1K\nQR2)6LD\n88G)G6R\nQGY)126\n5XC)X9S\nX5N)7VN\n8D8)97R\nPYX)KMM\nN8K)7B8\nMF9)PXY\n8WW)4NS\nJZ8)RVW\nH1M)78C\nQZV)3XV\nYZY)66Z\nWFZ)44F\n3Q5)PPH\nNTG)SNM\nHBK)CM6\n6JF)CH7\nCVB)Y9X\nF5G)TZN\n95K)Y1R\n614)54L\nTPP)66G\n4BR)8WW\nYJ7)W1R\nQ9R)773\nYH2)SY4\n2CF)3Q6\nGK1)NPV\n6PL)TL2\n6RQ)X5N\nTGK)52W\n7HJ)SC4\n7B8)L8S\nMKR)88G\nSC2)DLX\nSF9)KFC\nQSZ)KBD\nVL2)S9X\nLV6)HK5\nFMJ)8R2\n9YR)YLZ\nN23)V3F\nB6R)DXF\nM5V)KZH\n6VY)CRW\nT3Z)MQJ\nJVM)WFJ\n33M)9G7\nW45)VFH\nYZY)1LY\nHR1)QF5\nJGN)QB9\n991)F5G\n78C)J27\n8XW)5SB\nBHN)4SY\nLKB)BSK\n3DL)GQR\n9XC)B6V\nL4C)PD6\nLN8)82C\nP2C)Z19\nSNM)C3D\n4SY)8NL\n8Q8)4RF\nQLD)NS6\nC7M)6HN\nPZG)TBV\nD6T)KFB\nDYJ)TLH\nPQJ)729\nZ7K)QQK\nZLD)Q49\nJT4)6PL\n49Y)WZ9\nX43)VNS\n3SZ)H25\nZF6)QGY\nSCD)FMJ\n6FC)RTP\nRMS)GZC\nVNS)961\nZ2Q)NJ7\nH3K)9XC\n9J3)6VB\nBRN)3HQ\nNQY)GTK\nD8W)F6F\nGMS)LXG\nL5Y)B1H\nHC5)KTM\nQVC)292\nMCN)G2X\nHC7)TNW\nQBX)1XH\nX1H)X5D\nNPV)SLY\nDYN)VD5\nCCW)7CP\nTG5)6Y7\n6PL)CYJ\n2LW)8H9\n77T)ZXN\nX5D)HJ2\nS82)2BW\n729)PL8\nY9V)8MW\nPCH)LZW\nXQN)3SN\nWC7)ZML\nV3S)JJK\nT46)XG7\nXF4)TPP\nSH8)2Y4\nWXT)892\nP9L)V6S\nPXY)JG4\nCY5)MF9\nX41)NQ6\nB9R)9HH\nM4P)91B\nRD6)QQ4\nSMZ)X49\n4DJ)BKH\nD6Q)F8Q\nZHJ)4ZZ\nMDM)QXG\nRMK)B5Z\n27F)1Y2\nJ87)Z39\nG65)5Y4\nNGQ)LP9\nZ34)MP9\nVLN)YPZ\nMHH)K6L\nF7L)JZ8\n9KL)8LZ\n5XS)TK1\nMNS)Z2X\n2KZ)K5M\nCZC)8LR\nRS8)7XJ\nM72)VHV\n6PN)TKL\nSG4)FBR\nSC9)5WZ\nN8L)ZTK\nXG7)MKK\nKB9)JL7\n1GQ)82G\nN4X)91W\nF6F)NR4\n44F)1SF\nSZH)CNJ\nV2D)F7M\nY77)RS8\nVD3)7P7\nLXG)S5B\nQXG)KDW\n2KV)T46\nXXJ)1BP\nZNZ)MBB\nBG4)Q94\nB5Z)CVD\n5WZ)T8K\n2MM)FLH\nCHW)V88\nFZS)DS2\nWZ5)LDJ\nBFQ)MKR\nY1R)YLV\nQLD)34L\n737)GPH\nQQX)1ZV\nCRW)T42\n73H)L9K\nG2B)VJV\n9G7)SH8\nZ3G)T3Z\n9YS)TGK\n7NY)27R\n8R2)WXT\nGPH)FS5\nKBD)7N8\nHM9)68B\n2YD)PD5\n9YS)38S\nZ8W)W8Z\n3KH)X4V\n6ZG)935\n36T)QX7\n9L5)SPK\nVLF)4L4\nXCK)GPP\n66Z)FFQ\nXXH)H4Q\nFWL)TQD\n9DN)YYQ\nF7M)4XZ\n7S4)BML\nL58)FCC\n739)XWV\nYQ4)FJJ\n3CT)JM3\nKSG)NMG\n6T5)JG6\nT8K)X8Y\nK6L)QQH\nP74)9HY\nJG4)9BK\n9FR)836\nTNW)6RL\nRR3)HD6\n26G)SCD\nHC5)B98\n72L)6G9\n6G9)1DT\n32D)FBZ\n1TY)C7S\nQQ4)43D\nRV9)5D5\n7P7)MCN\n5YW)6YX\nS99)6RQ\nRR1)YBD\nV6X)227\nSBL)6Y8\n6KM)X21\n66Y)4VT\n91L)4PK\nPD5)4K3\nY8Y)L1Y\nLHS)L4C\n1LY)SAN\nW8Z)L5Y\nV6X)KS8\n7FX)J87\nYXX)B4B\nCLQ)S8N\nJGW)H99\nWHC)SJL\nXMH)V5P\nVP8)BLG\nBCK)R55\n4PC)Q1T\nTBV)N23\nB66)JMZ\nYLV)TNS\n88G)4C6\nRLT)Q76\nRRS)WXZ\n43D)WQR\nZR3)HDY\nS2D)QQX\nDTC)BJR\nQ3X)YP6\n7QH)PWH\nWXJ)329\nSCK)1GQ\nQKG)GSV\nZHJ)HKT\nBML)CY5\nWFJ)46L\nTLH)36T\nVC9)QY2\n2CF)NFM\nZ4B)VYK\n46L)5KV\nGCH)X1H\n14D)3DL\nPD6)QZV\n34L)LHS\nX8Y)9HW\nQF5)KB9\n24D)WXB\nGVR)D8W\nPCY)PJK\n1QW)L48\nJ5L)LKS\nZQ9)JPX\nL9K)V7K\nX4V)4ZR\nSB7)8H6\nVF3)HHD\n2WR)QTH\nPPH)W66\nC23)ZKT\nHGM)XDC\nNS6)8GQ\nX58)991\nMLX)S3N\nZCB)14K\n29Q)5SD\nBH4)7D3\nFVK)NPP\nY9X)N2Q\nGH2)R79\nHJ2)739\nWXS)B66\nSY4)59D\nF2K)NTK\nHHD)35W\n935)4NJ\nZKT)C7M\nV2D)C9K\nHD6)2D9\nB98)SCK\nZF6)7J4\nPVN)L7Q\nSBM)F77\n3H8)29Q\nF2D)W41\nFLH)QV6\nYT8)S99\nGBQ)YT8\nWXZ)6MS\nC5W)WFB\nKV2)66Y\nTBR)L5P\nNL6)3SR\nSK6)ZCJ\nVYY)P54\n2L3)GV4\nK1X)ZS2\n7D3)Z4B\n384)457\n8R2)TGF\nZB8)CC7\nKS8)TYB\nRKB)2YT\nK1H)XXJ\n52W)S2D\nWF9)P61\nWP9)GG3\n95M)8BB\nW53)CP6\nCM6)R25\nGTK)TZM\nQ28)D68\nWC8)VD3\nJMG)KCW\n9HW)JFH\n9HY)92T\n8GQ)6KS\n62Z)9WY\nVRJ)81G\nTGL)VLN\nTGF)ZSL\nXW6)XJS\nTNL)XYQ\n9G9)PQJ\nVYK)4JY\nGMZ)PQ1\nNJK)L58\nXF8)JVM\nGQ2)GVR\nN2Q)XKQ\nSM4)TQR\nC4S)QVC\nQ76)LV6\nFMH)3D6\n7B8)C4S\nVYY)2KZ\n9L5)27F\n7FJ)T99\nGY4)JGW\nYYQ)WFY\nGV4)CRJ\n457)VSM\n7G3)1P9\nSKH)DYN\n4PK)9J3\n7S9)C22\n1KS)V6H\nYVS)N4X\n2YT)F4V\n4ZZ)ZBG\nFVM)PYX\n8BB)1QW\nPQ1)TCV\nNR4)5SX\n9WY)95M\nSPK)DC8\nW3D)VB3\nL93)3LK\nK9J)C9N\n4C6)MRG\nP5D)5XS\n4XY)HF2\nMFS)64G\nT33)R3T\nSFB)TV7\n78Q)FYL\n892)GK1\nGG2)N1F\nLTD)XF4\n5WX)NQY\nQNF)T33\nCYJ)6VH\nNTG)MFS"
problem = Problem.new(INPUT)
you_path = problem.path_for("YOU")
san_path = problem.path_for("SAN")
common_parent = (you_path & san_path).first

print "First problem: #{problem.count_orbits}\n"
print "Second problem: #{you_path.index(common_parent) + san_path.index(common_parent) - 2}\n"