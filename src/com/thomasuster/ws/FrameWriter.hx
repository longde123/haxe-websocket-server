package com.thomasuster.ws;
import haxe.io.BytesData;
import com.thomasuster.ws.output.BytesOutputProxy;
import haxe.io.Bytes;
class FrameWriter {
    
    public var output:BytesOutputProxy;
    public var payload:Bytes;
    
    var mask:Bytes;
    
	public function new():Void {
        mask = Bytes.alloc(4);
    }

    public function write():Void {
        var bytes:Bytes = Bytes.alloc(14);
        
        var b0:Int = 0;
        b0 |= 0x80; //FIN
        b0 |= 0x02; //BINARY OP
        bytes.set(0,b0);

        var b1:Int = 0;
        b1 |= 0x00; //MASK
        b1 |= payload.length; //Length
        bytes.set(1,b1);

        output.writeBytes(bytes, 0, 2);
        
        output.writeBytes(payload, 0, payload.length);
    }
//
//    /*
//    https://developer.mozilla.org/en-US/docs/Web/API/WebSockets_API/Writing_WebSocket_servers
//      0                   1                   2                   3
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