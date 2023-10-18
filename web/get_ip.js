function getLocalIPAddress(callback) {
    // Create a dummy RTCPeerConnection to gather candidate addresses.
    const pc = new RTCPeerConnection({ iceServers: [] });

    // Create a data channel to trigger candidate gathering.
    pc.createDataChannel("");

    // Create an offer and set local description.
    pc.createOffer()
        .then(offer => pc.setLocalDescription(offer))
        .then(() => {
            // Extract local candidate address from the SDP.
            const lines = pc.localDescription.sdp.split("\n");

            console.log(lines);
            const ipAddressLine = lines.find(line => line.startsWith("a=candidate"));
            if (ipAddressLine) {
                const ipAddress = ipAddressLine.split(" ")[4];
                callback(ipAddress);
            } else {
                console.error("No line starting with 'a=candidate' found.");
            }
        })
        .catch(error => {
            console.error("Error getting local IP address:", error);
            callback(null);
        });
}

window.getLocalIPAddress = getLocalIPAddress;
