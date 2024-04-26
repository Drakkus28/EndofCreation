//
//  ConnectionManager.swift
//  Stranded
//
//  Created by Laufer, Michael R on 4/11/18.
//  Copyright © 2018-2019 Laufer, Michael R. All rights reserved.
//

import Foundation
import GameplayKit
import MultipeerConnectivity

class ServiceManager : NSObject
{
    private let ServiceType = "game-data"
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    //var delegate : ServiceManagerDelegate?
    
    lazy var session : MCSession = {
            let session = MCSession(peer: self.myPeerID, securityIdentity: nil, encryptionPreference: .required)
            //session.delegate = self
            return session
    }()
    
    override init()
    {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: ServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: ServiceType)
        super.init()
        self.serviceAdvertiser.delegate = self
        self.serviceAdvertiser.startAdvertisingPeer()
        self.serviceBrowser.delegate = self
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }
    func send(data: /*[Data]*/Data)
    {
        NSLog("%@", "sendData: \(data) to \(session.connectedPeers.count) peers")
        if session.connectedPeers.count > 0
        {
            //for part in data
            //{
                do
                {
                    try self.session.send(data, toPeers: session.connectedPeers, with: .reliable)
                   }
                catch let error
                {
                    NSLog("%@", "Error sending: \(error)")
                }
            //}
        }
    }
}

extension ServiceManager : MCNearbyServiceAdvertiserDelegate
{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didRecieveInvetationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
}

extension ServiceManager : MCNearbyServiceBrowserDelegate
{
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
}
/*extension ServiceManager : MCSessionDelegate
{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState \(state)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map{$0.displayName})
    }
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let info = data
        self.delegate?.dataChanged(manager: self, data: info)
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL??, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }
}

protocol ServiceManagerDelegate {
    func connectedDevicesChanged(manager: ServiceManager, connectedDevices: [String])
    func dataChanged(manager: ServiceManager, data: Data)
}*/
