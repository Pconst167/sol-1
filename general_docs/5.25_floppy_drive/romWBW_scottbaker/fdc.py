# Raspberry Pi WD37C65 driver
# Scott Baker, https://www.smbaker.com/
#
# Borrowed liberally from the RomWBW floppy driver

from __future__ import print_function
import sys
import time

# MSR is CS=FDC, A0=0
# DATA is CS=FDC, A0=1
# DOR is CS=DOR
# DCR is CS=DCR

import wd37c65_direct_ext

FDM720 = 0
FDM144 = 1
FDM360 = 2
FDM120 = 3
FDM111 = 4

FRC_OK = 0
FRC_NOTIMPL = 1
FRC_CMDERR = 2
FRC_ERROR = 3
FRC_ABORT = 4
FRC_BUFMAX = 5
FRC_ABTERM = 8
FRC_INVCMD = 9
FRC_DSKCHG = 0x0A
FRC_ENDCYL = 0x0B
FRC_DATAERR = 0x0C
FRC_OVERRUN = 0x0D
FRC_NODATA = 0x0E
FRC_NOTWRIT = 0x0F
FRC_MISADR = 0x10
FRC_TOFDRRDY = 0x11
FRC_TOSNDCMD = 0x12
FRC_TOGETRES = 0x13
FRC_TOEXEC = 0x14
FRC_TOSEEKWT = 0x15
FRC_OVER_DRAIN = 0x16
FRC_OVER_CMDRES = 0x17
FRC_TO_READRES = 0x18
FRC_READ_ERROR = 0x19
FRC_WRITE_ERROR = 0x20
FRC_SHORT = 0x21
FRC_LONG = 0x22
FRC_INPROGRESS = 0x23

CFD_READ	 =	0B00000110	# CMD,HDS/DS,C,H,R,N,EOT,GPL,DTL --> ST0,ST1,ST2,C,H,R,N
CFD_READDEL	 =	0B00001100	# CMD,HDS/DS,C,H,R,N,EOT,GPL,DTL --> ST0,ST1,ST2,C,H,R,N
CFD_WRITE	 =	0B00000101	# CMD,HDS/DS,C,H,R,N,EOT,GPL,DTL --> ST0,ST1,ST2,C,H,R,N
CFD_WRITEDEL =	0B00001001	# CMD,HDS/DS,C,H,R,N,EOT,GPL,DTL --> ST0,ST1,ST2,C,H,R,N
CFD_READTRK	 =	0B00000010	# CMD,HDS/DS,C,H,R,N,EOT,GPL,DTL --> ST0,ST1,ST2,C,H,R,N
CFD_READID	 =	0B00001010	# CMD,HDS/DS --> ST0,ST1,ST2,C,H,R,N
CFD_FMTTRK	 =	0B00001101  # CMD,HDS/DS,N,SC,GPL,D --> ST0,ST1,ST2,C,H,R,N
CFD_SCANEQ	 =	0B00010001	# CMD,HDS/DS,C,H,R,N,EOT,GPL,STP --> ST0,ST1,ST2,C,H,R,N
CFD_SCANLOEQ =	0B00011001	# CMD,HDS/DS,C,H,R,N,EOT,GPL,STP --> ST0,ST1,ST2,C,H,R,N
CFD_SCANHIEQ =	0B00011101	# CMD,HDS/DS,C,H,R,N,EOT,GPL,STP --> ST0,ST1,ST2,C,H,R,N
CFD_RECAL	 =  0B00000111	# CMD,DS --> <EMPTY>
CFD_SENSEINT =  0B00001000	# CMD --> ST0,PCN
CFD_SPECIFY	 =  0B00000011	# CMD,SRT/HUT,HLT/ND --> <EMPTY>
CFD_DRVSTAT	 =  0B00000100	# CMD,HDS/DS --> ST3
CFD_SEEK	 =  0B00001111	# CMD,HDS/DS --> <EMPTY>
CFD_VERSION	 =  0B00010000	# CMD --> ST0

CFD_NAME = {CFD_READ: "READ",
            CFD_READDEL: "READDEL",
            CFD_WRITE: "WRITE",
            CFD_WRITEDEL: "WRITEDEL",
            CFD_READTRK: "READTRK",
            CFD_READID: "READID",
            CFD_FMTTRK: "FMTTRK",
            CFD_SCANEQ: "SCANEQ",
            CFD_SCANLOEQ: "SCANLOEQ",
            CFD_SCANHIEQ: "SCANHIEQ",
            CFD_RECAL: "RECAL",
            CFD_SENSEINT: "SENSEINT",
            CFD_SPECIFY: "SPECIFY",
            CFD_DRVSTAT: "DRVSTAT",
            CFD_SEEK: "SEEK",
            CFD_VERSION: "VERSION"}

class FDCException(Exception):
    def __init__(self, fstRC, msg=None):
        if not msg:
            msg="FDC Exception %2X" % fstRC
        Exception.__init__(self, msg)
        self.fstRC = fstRC

class FDC:
    def __init__(self, media = "144", verbose=True):
        self.verbose = verbose

        self.DOR_INIT = 0B00001100
        self.DOR_BR250 = self.DOR_INIT
        self.DOR_BR500 = self.DOR_INIT
        self.DCR_BR250 = 1
        self.DCR_BR500 = 0

        # dynamic
        self.ds = 0
        self.cyl = 0
        self.head = 0
        self.record = 0
        self.fillByte = 0xE5
        self.dop = 0
        self.idleCount = 0
        self.to = 0
        self.fdcReady = False
        self.motoSwap = False

        # unit data
        self.track = 0xFF

        self.dor = 0

        self.setMedia(media)

    def setMedia(self, what):
        if (what == "144") or (what == "pc144") or (what == "14.4") or (what == "1440") or (what == "pc1440"):
            self.set144()
        elif (what == "720") or (what == "pc720"):
            self.set720()
        elif (what == "360") or (what == "pc360"):
            self.set360()
        elif (what == "120") or (what == "pc120"):
            self.set120()
        elif (what == "111") or (what == "pc111"):
            self.set111()
        else:
            raise Exception("Unknown media %s"% what)

    def set360(self):
        self.numCyl = 0x28
        self.numHead = 2
        #self.numSec = 9  # redundant with self.secCount ??
        self.sot = 1
        self.secCount = 9
        self.eot = self.secCount
        self.secSize = 0x200
        self.N = 2  # 2 = 512 bytes/sector
        self.gapLengthRW = 0x2A
        self.gapLengthFormat = 0x50
        self.stepRate = (13 << 4) | 0  # srtHut
        self.headLoadTimeNonDma = (4 << 1) | 1  # hltNd
        self.DOR = self.DOR_BR250
        self.DCR = self.DCR_BR250
        self.media = FDM360

    def set9836(self):
        # HP 9836
        self.numCyl = 0x23
        self.numHead = 2
        #self.numSec = 0x0F  # redundant with self.secCount ??
        self.sot = 1
        self.secCount = 0x0F
        self.eot = self.secCount
        self.secSize = 0x100
        self.N = 1  # 1 = 256 bytes/sector
        self.gapLengthRW = 0x2A
        self.gapLengthFormat = 0x50
        self.stepRate = (13 << 4) | 0  # srtHut
        self.headLoadTimeNonDma = (4 << 1) | 1  # hltNd
        self.DOR = self.DOR_BR250
        self.DCR = self.DCR_BR250
        self.media = FDM360        

    def set720(self):
        self.numCyl = 0x50
        self.numHead = 2
        #self.numSec = 0x09
        self.sot = 1
        self.secCount = 0x09
        self.eot = self.secCount
        self.secSize = 0x200
        self.N = 2  # 2 = 512 bytes/sector
        self.gapLengthRW = 0x2A
        self.gapLengthFormat = 0x50
        self.stepRate = (13 << 4) | 0  # srtHut
        self.headLoadTimeNonDma = (4 << 1) | 1  # hltNd
        self.DOR = self.DOR_BR250
        self.DCR = self.DCR_BR250
        self.media = FDM720

    def set144(self):
        self.numCyl = 0x50
        self.numHead = 2
        #self.numSec = 0x12
        self.sot = 1
        self.secCount = 0x12
        self.eot = self.secCount
        self.secSize = 0x200
        self.N = 2  # 2 = 512 bytes/sector
        self.gapLengthRW = 0x1B
        self.gapLengthFormat = 0x6C
        self.stepRate = (13 << 4) | 0  # srtHut
        self.headLoadTimeNonDma = (8 << 1) | 1  # hltNd
        self.DOR = self.DOR_BR500
        self.DCR = self.DCR_BR500
        self.media = FDM144

    def set120(self):
        self.numCyl = 0x50
        self.numHead = 2
        #self.numSec = 0x0F
        self.sot = 1
        self.secCount = 0x0F
        self.eot = self.secCount
        self.secSize = 0x200
        self.N = 2  # 2 = 512 bytes/sector
        self.gapLengthRW = 0x1B
        self.gapLengthFormat = 0x54
        self.stepRate = (10 << 4) | 0  # srtHut
        self.headLoadTimeNonDma = (8 << 1) | 1  # hltNd
        self.DOR = self.DOR_BR500
        self.DCR = self.DCR_BR500
        self.media = FDM120

    def set111(self):
        self.numCyl = 0x28
        self.numHead = 2
        #self.numSec = 0x0F
        self.sot = 1
        self.secCount = 0x0F
        self.eot = self.secCount
        self.secSize = 0x200
        self.N = 2  # 2 = 512 bytes/sector
        self.gapLengthRW = 0x1B
        self.gapLengthFormat = 0x54
        self.stepRate = (13 << 4) | 0  # srtHut
        self.headLoadTimeNonDma = (25 << 1) | 1  # hltNd
        self.DOR = self.DOR_BR500
        self.DCR = self.DCR_BR500
        self.media = FDM111 

    def log(self, x, newline=True):
        if not self.verbose:
            return
        if newline:
            print(x, file=sys.stderr)
        else:
            print(x, end='', file=sys.stderr)

    # ------------ chip funcs -----------------

    def readDataBlock(self, count):
        status, blk = wd37c65_direct_ext.read_block(count)
        if status not in [FRC_OK, FRC_READ_ERROR]:
            raise FDCException(status)

        self.dskBuf = blk

    def writeDataBlock(self, count, autoTerminate=True):
        status = wd37c65_direct_ext.write_block(self.dskBuf, count, autoTerminate)
        if status not in [FRC_OK, FRC_WRITE_ERROR]:
            raise FDCException(status)

    def writeData(self, d):
        wd37c65_direct_ext.write_data(d)

    def drain(self):
        status = wd37c65_direct_ext.drain()
        if status != 0:
            raise FDCException(status)

    def wait_msr(self, mask, val):
        return wd37c65_direct_ext.wait_msr(mask, val)

    def get_msr(self):
        return wd37c65_direct_ext.get_msr()

    def readResult(self):
        status, blk = wd37c65_direct_ext.read_result()
        if status != 0:
            raise FDCException(status)

        self.frb = blk
        self.frbLen = len(self.frb)

    def resetFDC(self):
        wd37c65_direct_ext.reset(self.dor)

    def initFDC(self):
        wd37c65_direct_ext.init()

    def writeDOR(self, dor):
        wd37c65_direct_ext.write_dor(dor)
        self.dor = dor

    def writeDCR(self, dcr):
        wd37c65_direct_ext.write_dcr(dcr)
        self.dcr = dcr
    
    # -----------------------------------------

    def init(self):
        self.fcpBuf = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        self.idleCount = 0
        self.dor = self.DOR_INIT
        self.initFDC()
        self.resetFDC()
        self._clearDiskChange()
        self.fdcReady = True
        self.motorBoth = False

    def done(self):
        self._motorOff()

    def _reset(self):
        self.resetFDC()
        self._clearDiskChange()
        self.track = 0xFF  # mark needing recal
        self.fdcReady = True

    def read(self, cyl=None, head=None, record=None, retries=0):
        if cyl is not None:
            self.cyl = cyl
        if head is not None:
            self.head = head
        if record is not None:
            self.record = record

        while (retries >= 0):
            retries -= 1
            self._start()
            if (self.fstRC != FRC_OK):
                print("*** read _start retry %02X" % self.fstRC, file=sys.stderr)
                continue

            self._setupIO(CFD_READ | 0B11100000)
            self._fop()

            if self.fstRC == FRC_OK:
                return self.fstRC

            print("*** read retry %02X" % self.fstRC, file=sys.stderr)

        # retries exhausted
        return self.fstRC

    def write(self, cyl=None, head=None, record=None, retries=0):
        if cyl is not None:
            self.cyl = cyl
        if head is not None:
            self.head = head
        if record is not None:
            self.record = record

        while (retries >= 0):
            retries -= 1
            self._start()
            if (self.fstRC != FRC_OK):
                print("*** write _start retry %02X" % self.fstRC, file=sys.stderr)
                continue

            self._setupIO(CFD_WRITE | 0B11000000)
            self._fop()

            if self.fstRC == FRC_OK:
                return self.fstRC

            print("*** write retry %02X" % self.fstRC, file=sys.stderr)

        # retries exhausted
        return self.fstRC

    def format(self, cyl=None, head=None, retries=0):
        if cyl is not None:
            self.cyl = cyl
        if head is not None:
            self.head = head

        self.dskBuf = ""
        for i in range(0, self.secCount):
            self.dskBuf += chr(self.cyl)
            self.dskBuf += chr(self.head)
            self.dskBuf += chr(i+1)  # secNum
            self.dskBuf += chr(self.N)  # 2 = 512 bytes per sector

        while (retries >= 0):
            retries -= 1
            self._start()
            if (self.fstRC != FRC_OK):
                print("*** format _start retry %02X" % self.fstRC, file=sys.stderr)
                continue

            self._setupFormat(CFD_FMTTRK | 0B01000000)
            self._fop()

            if self.fstRC == FRC_OK:
                return self.fstRC

            print("*** format retry %02X" % self.fstRC, file=sys.stderr)

        # retries exhausted
        return self.fstRC

    def readID(self):
        self._setupCommand(CFD_READID | 0B01000000)
        return self._fop()

    def _recal(self):
        self._setupCommand(CFD_RECAL)
        return self._fop()

    def _senseInt(self):
        self._setupCommand(CFD_SENSEINT)
        self.fcpLen = 1
        return self._fop()       

    def _specify(self, stepRate=None, headLoadTimeNonDma=None):
        if stepRate:
            self.stepRate = stepRate
        if headLoadTimeNonDma:
            self.headLoadTimeNonDma = headLoadTimeNonDma
        self._setupSpecify()
        return self._fop()

    def _seek(self):
        self._setupSeek()
        return self._fop()

    def _start(self):
        if not self.fdcReady:
            self.log(">>> start:reset")
            self._reset()
            if self.fstRC != FRC_OK:
                return self.fstRC

        self._motorOn()

        if self.track == 0xFF:
            self.log(">>> start:driveReset")
            self._driveReset()
            if self.fstRC != FRC_OK:
                return self.fstRC

        if self.track != self.cyl:
            self.log(">>> start:seek (%d,%d)" % (self.track, self.cyl))
            self._seek()
            if self.fstRC != FRC_OK:
                return self.fstRC
            self._waitSeek()
            if self.fstRC != FRC_OK:
                return self.fstRC
            self.track = self.cyl

        self.fstRC = FRC_OK
        return self.fstRC

    def _driveReset(self):
        self.log(">>> driveReset:specify")
        self._specify()
        if self.fstRC != FRC_OK:
            return self.fstRC

        self.log(">>> driveReset:recal")
        self._recal()
        if self.fstRC != FRC_OK:
            return self.fstRC

        self.log(">>> driveReset:waitseek1")
        self._waitSeek()
        if (self.fstRC == FRC_OK):
            # succeeded!
            return self.fstRC

        # try once more
        self.log(">>> driveReset:waitseek2")
        self._waitSeek()   
        return self.fstRC

    def _motorOn(self):
        # DOR bit 0 is DS, either 0 or 1
        # DOR bit 4 is motor enable for ds0
        # DOR bit 5 is motor enable for ds1
        if self.motorBoth:
            motorMask = (3 << 4)
        else:
            motorMask = (1 << (self.ds+4))
        self.writeDOR(self.dor & 0B11111100 | self.ds | motorMask)
        self.writeDCR(self.DCR)

        if (self.dor & motorMask)==0:
            self.log(">>> motor delay")
            # motor delay
            time.sleep(1)

    def _motorOff(self):
        self.dor = self.DOR_INIT
        self.writeDOR(self.dor)

    def _clearDiskChange(self):
        for i in range(0, 5):
            self._senseInt()
            if (self.fstRC & FRC_DSKCHG) == 0:
                return
        # I think we can just ignore the remaining ones

    def _setupCommand(self, cmd):
        self.fcpBuf[0] = cmd & 0x5F
        self.fcpCmd = (cmd & 0x5F) & 0B00011111
        self.fcpBuf[1] = ((self.head & 0x1)<<2) | (self.ds & 0x3)
        self.fcpLen = 2

    def _setupSeek(self):
        self._setupCommand(CFD_SEEK)
        self.fcpBuf[2] = self.cyl
        self.fcpLen = 3

    def _setupSpecify(self):
        self._setupCommand(CFD_SPECIFY)
        self.fcpBuf[1] = self.stepRate
        self.fcpBuf[2] = self.headLoadTimeNonDma
        self.fcpLen = 3

    def _setupIO(self, cmd):
        self._setupCommand(cmd)
        self.fcpBuf[2] = self.cyl
        self.fcpBuf[3] = self.head
        self.fcpBuf[4] = self.record
        self.fcpBuf[5] = self.N  # sector size, 2 = 512 bytes
        self.fcpBuf[6] = self.eot
        self.fcpBuf[7] = self.gapLengthRW
        self.fcpBuf[8] = self.gapLengthFormat
        self.fcpLen = 9

    def _setupFormat(self, cmd):
        self._setupCommand(cmd)
        self.fcpBuf[2] = self.N  # sector size, 2 = 512 bytes
        self.fcpBuf[3] = self.secCount
        self.fcpBuf[4] = self.gapLengthFormat
        self.fcpBuf[5] = self.fillByte
        self.fcpLen = 6

    def _cfdName(self, x):
        x = x & 0B1111
        return CFD_NAME.get(x, "UNKNOWN")

    def _fop(self):
        try:
            fcpBytes = []
            for i in range(0, self.fcpLen):
                fcpBytes.append("%02X" % self.fcpBuf[i])

            self.log("FOP <%s> %s ->" % (self._cfdName(self.fcpBuf[0]), (" ".join(fcpBytes))), newline=False)

            result = self._fop_internal()

            frbBytes = []
            for i in range(0, self.frbLen):
                frbBytes.append("%02X" % ord(self.frb[i]))
            self.log("-> [result %02X] %s" % (result, (" ".join(frbBytes))))
            return result
        except FDCException as e:
            print("Exception in _Fop %s, code %2X" % (e, e.fstRC), file=sys.stderr)
            self.fstRC = e.fstRC
            return self.fstRC

    def _fop_internal(self):
        self.frbLen = 0
        self.fstRC = FRC_OK

        self.drain()

        time.sleep(0.001)

        if (self.get_msr() & 0x90) == 0x90:
            # Idiot-Check, this should never happen.
            print("Holy Corrupted Floppy Drivers, Batman! We're in the middle of a read or write already!\n", file=sys.stderr)
            self.fdcReady = False;
            self.fstRC = FRC_INPROGRESS
            return self.fstRC

        for i in range(0, self.fcpLen):
            # DIO=0 and RQM=1 indicate byte is ready to write
            self.fstRC = self.wait_msr(0xC0, 0x80)
            if (self.fstRC!=0):
                self.log("Sendcommand error in wait_msr %02X" % self.fstRC)
                return self.fstRC
            self.writeData(self.fcpBuf[i])

        #fcpStr = ""
        #for i in range(0, self.fcpLen):
        #    fcpStr = fcpStr + chr(self.fcpBuf[i])
        #wd37c65_direct_ext.write_command(fcpStr, self.fcpLen)

        # execution phase

        if (self.fcpCmd == CFD_READ):
            self.readDataBlock(self.secSize)
        elif (self.fcpCmd == CFD_WRITE):
            self.writeDataBlock(self.secSize)
        elif (self.fcpCmd == CFD_FMTTRK):
            self.writeDataBlock(4 * self.secCount)
        elif (self.fcpCmd == CFD_READID):
            self.waitMSR(0xE0, 0xC0)
        else:
            pass  # null

        self.frb = ""
        self.readResult()

        if (self.fcpCmd == CFD_DRVSTAT):
            # driveState has nothing to evaluate
            return self.fstRC
        elif (self.frbLen == 0):
            # if there's no st0, then nothing to evaluate
            return self.fstRC

        st0 = ord(self.frb[0])
        if (st0 & 0B11000000) == 0B01000000:
            # ABTERM
            if (self.fcpCmd == CFD_SENSEINT) or (self.frbLen == 1):
                # Senseint doesn't use ST1
                self.fstRC = FRC_ABTERM
                return self.fstRC

            # evalst1
            st1 = ord(self.frb[1])
            if (st1 & 80) == 0x80:
                self.fstRC = FRC_ENDCYL
            elif (st1 & 0x20) == 0x20:
                self.fstRC = FRC_DATAERR
            elif (st1 & 0x10) == 0x10:
                self.fstRC = FRC_OVERRUN
            elif (st1 & 0x04) == 0x08:
                self.fstRC = FRC_NODATA
            elif (st1 & 0x02) == 0x04:
                self.fstRC = FRC_NOWRIT
            elif (st1 & 0x01) == 0x01:
                self.fstRC = FRC_MISADR
            
            return self.fstRC
        elif (st0 & 0B11000000) == 0B10000000:
            # INVCMD
            self.fstRC = FRC_INVCMD
            return self.fstRC
        elif (st0 & 0B11000000) == 0B11000000:
            # DSKCHG
            self.fstRC = FRC_DSKCHG
            return self.fstRC

        # no error bits are set

        return self.fstRC

    def _waitSeek(self):
        loopCount = 0x1000
        while (loopCount>0):
            self._senseInt()
            if self.fstRC == FRC_ABTERM:
                # seek error
                return self.fstRC
            elif self.fstRC == FRC_OK:
                return self.fstRC
            loopCount -= 1

        self.fstRC = FRC_TOSEEKWT
        return self.fstRC

