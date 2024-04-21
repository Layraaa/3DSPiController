# 3DSPiController
With this utility you can transform your Raspberry Pi in a hotspot, where a 3DS can be connected to redirect the inputs from your controller connected in the Raspberry Pi to your 3DS. It will be installed:
- Controller drivers
- [FakeMii](https://github.com/Lectem/fakemii)
- hostapd and dnsmasq to create the hotspot
- [Input Redirection Client](https://github.com/TuxSH/InputRedirectionClient-Qt)

## Requeriments
- A Raspberry Pi (Any model) with [Raspbian OS](https://www.raspberrypi.com/software/) installed (Desktop Environment)
- A modified 3DS with [Luma](https://github.com/LumaTeam/Luma3DS)
- A Xbox wired controller (You can use a controller form another brand or a bluetooth controller if you can set it up, in my case I install drivers and libraries that I need for the Xbox controller)

## Installation
```
git clone https://github.com/Layraaa/3DSPiController
cd 3DSPiController
bash 3DSPiController.sh
```
## Setup in 3DS
- Go to system settings
- Internet settings
- New connection
- Manual settings
- Set SSID, password and proxy server
  - For set the proxy, go to advanced settings
  - Proxy Server: 192.168.4.1
  - Port: 3000
- Run the connection test

## Use
- Connect your controller to the Raspberry Pi
- Turn on the Raspberry Pi
- When you see that the 3DS is connected, press L+Down+Select and enter in Rosalina Menu
   - Miscellaneous options
   - Start InputRedirection
   - Enjoy!
