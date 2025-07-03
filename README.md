
# cups-munbyn

This is a Unraid container based on Florian Schwabs docker container that is available on CA (ydkn/cups), but enables the usage of atleast Rollo, Munbyn and Beeprt thermal printers, maybe also others.


## Deployment

Since this probably won't be published in Unraids CA you need to retrieve repository and add all the Docker variables yourself. **PLEASE NOTE THAT DRAG-AND-DROP FEATURE USES pdfcrop AUTOMATIC CROP**

You can pick the name yourself, I've gone ahead a named my container munbyn-cups

![alt text](https://github.com/TheKents0209/cups-munbyn/blob/main/readme-images/Screenshot%202025-07-03%20at%2012.50.37.png "Here is how i've done it")

In repository field, enter: `thekents/munbyn-cups`, I also recommend to change Console shell command to Bash.


| Config type | Name               | Container Path / Port / KEY | Host Path / Port / VALUE       | Default Value              | Connection type |
|-------------|--------------------|-----------------------------|-------------------------------|----------------------------|-----------------|
| Path        | USB Mapping        | /var/run/dbus               | /var/run/dbus                 | /var/run/dbus              |                 |
| Path        | Config file        | /etc/cups/                  | /mnt/user/appdata/cups/       | /mnt/user/appdata/cups     |                 |
| Port        | Web interface port | 631                         | 631                           | 631                        | TCP             |
| Variable    | ADMIN_PASSWORD     | ADMIN_PASSWORD              | admin                         | admin                      |                 |
| Device      | Printer            |                             | /dev/bus/usb/001/003          |                            |                 |

Device value is found:

Run `lsusb` and find your printer.

E.g.: Bus 003 Device 009: ID 03f0:c111 Hewlett-Packard Deskjet 1510

It's the Bus 003 Device 009, so the path to is should be: /dev/bus/usb/003/009


If you want to drag and drop files into a folder then you need to create a user share called print_queue and also need to add the following paths to the container: 

| Config type | Name             | Container Path | Host Path                   | Default Value               | Access Mode  |
|-------------|------------------|----------------|-----------------------------|-----------------------------|--------------|
| Path        | Print Queue      | /print_queue   | /mnt/user/print_queue/       | /mnt/user/print_queue/       | Read/Write   |
| Path        | Completed prints | /completed     | /mnt/user/print_queue/completed/ | /mnt/user/print_queue/completed/ | Read/Write   |
 

After settings these up, you can go ahead a hit Apply.
- Then navigate to https://[HOST]:631/ (HOST is your server IP)
- Add printers: Administration > Printers > Add Printer

Munbyn printer should be found under Local Printers. Continue until you have to upload .ppd file, upload **ThermalPrinterMunbynUpd.ppd** that is in this repo.

NOTE: To use drag and drop from other computer, you will need to check **Share This Printer**


After setting this up, your thermal printer should work.
