# Wildfire

Wildfire collects network performance data to inform decisions for multi-region and peer-to-peer applications.

For realtime applications with strict latency requirements, there are a few internet protocols available, some of which are more suitable than others. Wildfire helps web engineers determine the feasibility of connections between two regions by measuring performance between two servers using a set of common web protocols.

The application is backed by Erlang's BEAM virtual machine and OTP framework, the Elixir programming language, and the Phoenix framework.

## Measurements

Using the Fly.io hosting platform, Wildfire connects a server in two regions and performs the following measurements:

- [ ] IP Ping
- [ ] HTTP
- [ ] WebSocket
- [ ] WebRTC
- [ ] UDP
- [ ] Bandwidth
- [ ] Packet loss

## TODO

- [ ] List Fly regions
- [ ] Maybe default first field to user's nearest region
- [ ] Allow user to select two Fly regions
- [ ] Ensure two unique regions are selected
- [ ] Ensure two valid regions are selected
- [ ] On submit, fetch measurement data
- [ ] Cache measurement data for 14 days to keep costs low
- [ ] Render popular / recent measurements
- [ ] Handle timeouts and errors
- [ ] Subscribe to PubSub topic with the two selected regions
- [ ] Broadcast new measurements to subscribers
