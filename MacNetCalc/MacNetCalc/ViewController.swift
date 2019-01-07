//
//  ViewController.swift
//  MacNetCalc
//
//  Created by xiyue on 2019/1/6.
//  Copyright © 2019 xiyue. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var NetClass:[String:String] = ["label":"", "type":""]
    var SubnetBits: Int32 = 0
    var HostBits: Int32 = 0
    var NetAddr: [Int32] = [0, 0, 0, 0]
    var HostAddr: [Int32] = [0, 0, 0, 0]
    var NetMask: [Int32] = [0, 0, 0, 0]
    var WildcardMask: [Int32] = [0, 0, 0, 0]
    var Broadcast: [Int32] = [0, 0, 0, 0]
    var FirstHost: [Int32] = [0, 0, 0, 0]
    var LastHost: [Int32] = [0, 0, 0, 0]
    var isAddrRange: Int32 = 0
    var MaxHosts: UInt64 = 0
    var MaxSubnets: UInt64 = 0
    var NetMaskBad: Int32 = 0
    var NetmaskBits: Int32 = 0
    var z8:String = "00000000"
    

    @IBOutlet weak var lblHostOctet0: NSTextField!
    @IBOutlet weak var lblHostOctet1: NSTextField!
    @IBOutlet weak var lblHostOctet2: NSTextField!
    @IBOutlet weak var lblHostOctet3: NSTextField!

    @IBOutlet weak var lblHostBinOctet0: NSTextField!
    @IBOutlet weak var lblHostBinOctet1: NSTextField!
    @IBOutlet weak var lblHostBinOctet2: NSTextField!
    @IBOutlet weak var lblHostBinOctet3: NSTextField!
    
    @IBOutlet weak var lblMaskBinOctet0: NSTextField!
    @IBOutlet weak var lblMaskBinOctet1: NSTextField!
    @IBOutlet weak var lblMaskBinOctet2: NSTextField!
    @IBOutlet weak var lblMaskBinOctet3: NSTextField!
    
    @IBOutlet weak var lblNtwkBinOctet0: NSTextField!
    @IBOutlet weak var lblNtwkBinOctet1: NSTextField!
    @IBOutlet weak var lblNtwkBinOctet2: NSTextField!
    @IBOutlet weak var lblNtwkBinOctet3: NSTextField!
    
    @IBOutlet weak var lblBCastBinOctet0: NSTextField!
    @IBOutlet weak var lblBCastBinOctet1: NSTextField!
    @IBOutlet weak var lblBCastBinOctet2: NSTextField!
    @IBOutlet weak var lblBCastBinOctet3: NSTextField!
    
    @IBOutlet weak var lblNetworkInfo: NSTextField!
    @IBOutlet weak var lblSubNetType: NSTextField!
    
    @IBOutlet weak var lblNetBitsSlider: NSSlider!
    @IBOutlet weak var lblNetMaskBits: NSTextField!
    @IBOutlet weak var lblSubnetBits: NSTextField!
    @IBOutlet weak var lblHostBits: NSTextField!
    @IBOutlet weak var lblMaxSubnets: NSTextField!
    @IBOutlet weak var lblMaxHosts: NSTextField!
    
    @IBOutlet weak var lblNetworkAddr: NSTextField!
    @IBOutlet weak var lblNetworkAddr2: NSTextField!
    @IBOutlet weak var lblNetMask: NSTextField!
    @IBOutlet weak var lblNetMask2: NSTextField!
    @IBOutlet weak var lblWildcardMask: NSTextField!
    @IBOutlet weak var lblWildcardMask2: NSTextField!
    @IBOutlet weak var lblBCastAddr: NSTextField!
    @IBOutlet weak var lblBCastAddr2: NSTextField!
    @IBOutlet weak var lblFirstHost: NSTextField!
    @IBOutlet weak var lblLastHost: NSTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doCalc(IPaddr: [1, 0, 0, 0], MaskBits: 8)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func sliderUpdate(_ sender: Any) {
        lblNetMaskBits.stringValue = String(lblNetBitsSlider.intValue)
        doCalc(IPaddr: [lblHostOctet0.intValue, lblHostOctet1.intValue, lblHostOctet2.intValue, lblHostOctet3.intValue], MaskBits: lblNetBitsSlider.intValue)
    }
    
    @IBAction func HostIPUpdate(_ sender: Any) {
        let addr: [Int32] = [lblHostOctet0.intValue, lblHostOctet1.intValue, lblHostOctet2.intValue, lblHostOctet3.intValue]
        if addr[0] >= 224 {
            lblNetBitsSlider.intValue = 32
        } else if addr[0] >= 192 {
            lblNetBitsSlider.intValue = 24
        } else if addr[0] >= 128 {
            lblNetBitsSlider.intValue = 16
        } else {
            lblNetBitsSlider.intValue = 8
        }
        doCalc(IPaddr: addr, MaskBits: lblNetBitsSlider.intValue)
    }
    
    func doCalc(IPaddr:[Int32], MaskBits:Int32) {
        CalcHosts(IPaddr: IPaddr, MaskBits: MaskBits)
        updateFields()
    }
    
    func updateFields() {
        
        lblHostOctet0.stringValue = String(HostAddr[0])
        lblHostOctet1.stringValue = String(HostAddr[1])
        lblHostOctet2.stringValue = String(HostAddr[2])
        lblHostOctet3.stringValue = String(HostAddr[3])
        
        lblNetworkInfo.stringValue = NetClass["label"]!
        lblSubNetType.stringValue = NetClass["type"]!

        // set Netmask bits field
        lblNetBitsSlider.intValue = NetmaskBits
        lblNetMaskBits.stringValue = String(lblNetBitsSlider.intValue)
        if NetClass["type"]! == "Supernetting" {
            // set Subnet bits field
            lblSubnetBits.stringValue = ""
            // set Host bits field
            lblHostBits.stringValue = ""
            // set MaxSubnets field
            lblMaxSubnets.stringValue = ""
            // set MaxHosts field
            lblMaxHosts.stringValue = ""

        } else {
            // set Subnet bits field
            lblSubnetBits.stringValue = String(SubnetBits)
            // set Host bits field
            lblHostBits.stringValue = String(HostBits)
            // set MaxSubnets field
            lblMaxSubnets.stringValue = String(MaxSubnets)
            // set MaxHosts field
            lblMaxHosts.stringValue = String(MaxHosts)

        }
        // set network address fields
        lblNetworkAddr.stringValue = String(format: "%d.%d.%d.%d", NetAddr[0], NetAddr[1], NetAddr[2], NetAddr[3])
        lblNetworkAddr2.stringValue = String(format: "%d.%d.%d.%d", NetAddr[0], NetAddr[1], NetAddr[2], NetAddr[3])
        // set Netmask address fields
        lblNetMask.stringValue = String(format: "%d.%d.%d.%d", NetMask[0], NetMask[1], NetMask[2], NetMask[3])
        lblNetMask2.stringValue = String(format: "%d.%d.%d.%d", NetMask[0], NetMask[1], NetMask[2], NetMask[3])
        // set Wildcard Mask fileds
        lblWildcardMask.stringValue = String(format: "%d.%d.%d.%d", WildcardMask[0], WildcardMask[1], WildcardMask[2], WildcardMask[3])
        lblWildcardMask2.stringValue = String(format: "%d.%d.%d.%d", WildcardMask[0], WildcardMask[1], WildcardMask[2], WildcardMask[3])
        // set Broadcast Address field
        lblBCastAddr.stringValue = String(format: "%d.%d.%d.%d", Broadcast[0], Broadcast[1], Broadcast[2], Broadcast[3])
        lblBCastAddr2.stringValue = String(format: "%d.%d.%d.%d", Broadcast[0], Broadcast[1], Broadcast[2], Broadcast[3])
        // set First host field
        lblFirstHost.stringValue = String(format: "%d.%d.%d.%d", FirstHost[0], FirstHost[1], FirstHost[2], FirstHost[3])
        // set Last host field
        lblLastHost.stringValue = String(format: "%d.%d.%d.%d", LastHost[0], LastHost[1], LastHost[2], LastHost[3])
        // set binary Host fields
        lblHostBinOctet0.stringValue = String((z8 + String(HostAddr[0],radix:2)).suffix(8))
        lblHostBinOctet1.stringValue = String((z8 + String(HostAddr[1],radix:2)).suffix(8))
        lblHostBinOctet2.stringValue = String((z8 + String(HostAddr[2],radix:2)).suffix(8))
        lblHostBinOctet3.stringValue = String((z8 + String(HostAddr[3],radix:2)).suffix(8))
        // set binary Netmask fields
        lblMaskBinOctet0.stringValue = String((z8 + String(NetMask[0],radix:2)).suffix(8))
        lblMaskBinOctet1.stringValue = String((z8 + String(NetMask[1],radix:2)).suffix(8))
        lblMaskBinOctet2.stringValue = String((z8 + String(NetMask[2],radix:2)).suffix(8))
        lblMaskBinOctet3.stringValue = String((z8 + String(NetMask[3],radix:2)).suffix(8))
        // set binary network fields
        lblNtwkBinOctet0.stringValue = String((z8 + String(NetAddr[0],radix:2)).suffix(8))
        lblNtwkBinOctet1.stringValue = String((z8 + String(NetAddr[1],radix:2)).suffix(8))
        lblNtwkBinOctet2.stringValue = String((z8 + String(NetAddr[2],radix:2)).suffix(8))
        lblNtwkBinOctet3.stringValue = String((z8 + String(NetAddr[3],radix:2)).suffix(8))
        // set binary broadcast fields
        lblBCastBinOctet0.stringValue = String((z8 + String(Broadcast[0],radix:2)).suffix(8))
        lblBCastBinOctet1.stringValue = String((z8 + String(Broadcast[1],radix:2)).suffix(8))
        lblBCastBinOctet2.stringValue = String((z8 + String(Broadcast[2],radix:2)).suffix(8))
        lblBCastBinOctet3.stringValue = String((z8 + String(Broadcast[3],radix:2)).suffix(8))
    }
    
    func initVars() {
        NetClass = ["label":"", "type":""]
        SubnetBits = 0
        NetAddr = [0, 0, 0, 0]
        HostAddr = [0, 0, 0, 0]
        NetMask = [0, 0, 0, 0]
        WildcardMask = [0, 0, 0, 0]
        Broadcast = [0, 0, 0, 0]
        FirstHost = [0, 0, 0, 0]
        LastHost = [0, 0, 0, 0]
        isAddrRange = 0
        MaxHosts = 0
        MaxSubnets = 0
        NetMaskBad = 0
        NetmaskBits = 0
    }
    
    func CalcHosts(IPaddr:[Int32], MaskBits:Int32) {

        var n:Int = Int(MaskBits / 8)
        
        initVars()
        HostAddr = IPaddr
        NetmaskBits = MaskBits
        
        while n > 0 {
            n -= 1
            NetMask[n] = 255
        }
        n  = Int(MaskBits % 8 - 1)
        if n >= 0 {
            for i in 7-n...7 {
                NetMask[Int(MaskBits / 8)] = NetMask[Int(MaskBits / 8)] + 1 << i
            }
        }

        
        if IPaddr[0] >= 240 {
            NetClass["label"] = "Class E (reserved)"
        } else if IPaddr[0] >= 224 {
            NetClass["label"] = "Class D (multicast)"
        } else if IPaddr[0] >= 192 {
            NetClass["label"] = "Class C Network"
            SubnetBits = MaskBits - 24
        } else if IPaddr[0] >= 128 {
            NetClass["label"] = "Class B Network"
            SubnetBits = MaskBits - 16
        } else {
            NetClass["label"] = "Class A Network"
            SubnetBits = MaskBits - 8
        }
        if SubnetBits > 0 {
            NetClass["type"] = "Warning! Subnet - All 0's"
            MaxSubnets = (1 << SubnetBits) - 2
        } else if SubnetBits < 0 {
            NetClass["type"] = "Supernetting"
        } else {
            NetClass["type"] = "Subnetting"
        }
        for i in 0...3 {
            NetAddr[i] = HostAddr[i] & NetMask[i]
            Broadcast[i] = HostAddr[i] | (~NetMask[i] & 0xFF)
            WildcardMask[i] = NetMask[i] ^ 0xFF
        }
        if (NetmaskBits >= 0) && (NetmaskBits <= 30) {
            for i in 0...3 {
                FirstHost[i] = NetAddr[i]
                LastHost[i] = Broadcast[i]
            }
            FirstHost[3] = FirstHost[3] + 1
            LastHost[3] = LastHost[3] - 1
            HostBits = 32 - NetmaskBits
            MaxHosts = (0x01 << HostBits) - 2
        }
        
    }


}

