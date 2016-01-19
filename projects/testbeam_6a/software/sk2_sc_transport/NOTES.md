Address map:

```
root@testbeam_6a:~# cat /sys/class/uio/uio0/maps/map0/name 
/amba_pl/axi_bram_ctrl@40000000
root@testbeam_6a:~# cat /sys/class/uio/uio1/maps/map0/name 
/amba_pl/axi_bram_ctrl@42000000
root@testbeam_6a:~# cat /sys/class/uio/uio2/maps/map0/name 
/amba_pl/myip@43c00000
root@testbeam_6a:~# cat /sys/class/uio/uio3/maps/map0/name 
/amba_pl/myip@43c10000
```

Use hardcoded addresses?

```
/* Hardware definitions */
#define FMCIO_1_CR_BASEADDR   0x43C00000
#define FMCIO_1_CR_HIGHADDR   0x43C0FFFF
#define FMCIO_1_CR_SIZE       0x10000

#define FMCIO_1_SR_BASEADDR   0x43C10000
#define FMCIO_1_SR_HIGHADDR   0x43C1FFFF
#define FMCIO_1_SR_SIZE       0x10000

#define FMCIO_1_SEND_BASEADDR 0x40000000
#define FMCIO_1_SEND_HIGHADDR 0x4001FFFF
#define FMCIO_1_SEND_SIZE     0x20000

#define FMCIO_1_RECV_BASEADDR 0x42000000
#define FMCIO_1_RECV_HIGHADDR 0x4201FFFF
#define FMCIO_1_RECV_SIZE     0x20000
```
