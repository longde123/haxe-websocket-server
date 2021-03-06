package com.thomasuster.ws;
import com.thomasuster.ws.output.BytesOutputProxy;
import haxe.io.Bytes;
class FrameWriter {
    
    public var output:BytesOutputProxy;
    public var payload:Bytes;
    
    var mask:Bytes;
    var header:Bytes;
    
	public function new():Void {
        mask = Bytes.alloc(4);
        header = Bytes.alloc(14);
    }

    public function write():Void {
        header.fill(0,header.length,0);
        var numUsed:Int = 2;
        
        var b0:Int = 0;
        b0 |= 0x80; //FIN
        b0 |= 0x02; //BINARY OP
        header.set(0,b0);

        var b1:Int = 0;
        b1 |= 0x00; //MASK
        if(payload.length >= 126) {
            if(payload.length >= 65535) {
                numUsed = 10;
                b1 |= 127;   
            }
            else {
                numUsed = 4;
                b1 |= 126;
            }
        }
        else
            b1 |= payload.length;
        header.set(1,b1);
        
        if(numUsed == 4) {
            var bExtended:Int = 0;
            bExtended |= payload.length;
            header.set(2, bExtended >>> 8);
            header.set(3, bExtended & 0x00FF);
        }
        else if(numUsed == 10) {
            var bExtended:Int = 0;
            bExtended |= payload.length;
            header.set(6, bExtended >>> 24);
            header.set(7, bExtended >>> 16);
            header.set(8, bExtended >>> 8);
            header.set(9, bExtended);
        }

        output.writeFullBytes(header, 0, numUsed);
        
        output.writeFullBytes(payload, 0, payload.length);
    }
//
//    /*
//    https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API/Writing_WebSocket_servers
//      0                   1                   2                   3 //dec
//      0               1               2               3             //bytes
//      0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
//     +-+-+-+-+-------+-+-------------+-------------------------------+
//     |F|R|R|R| opcode|M| Payload len |    Extended payload length    |
//     |I|S|S|S|  (4)  |A|     (7)     |             (16/64)           |
//     |N|V|V|V|       |S|             |   (if payload len==126/127)   |
//     | |1|2|3|       |K|             |                               |
//     +-+-+-+-+-------+-+-------------+ - - - - - - - - - - - - - - - +
//     |     Extended payload length continued, if payload len == 127  |
//     + - - - - - - - - - - - - - - - +-------------------------------+
//     |                               |Masking-key, if MASK set to 1  |
//     +-------------------------------+-------------------------------+
//     | Masking-key (continued)       |          Payload Data         |
//     +-------------------------------- - - - - - - - - - - - - - - - +
//     :                     Payload Data continued ...                :
//     + - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - +
//     |                     Payload Data continued ...                |
//     +---------------------------------------------------------------+
//    */
}
