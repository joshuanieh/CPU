module dcache_sram
(
    clk_i,
    rst_i,
    addr_i,
    tag_i,
    data_i,
    enable_i,
    write_i,
    tag_o,
    data_o,
    hit_o
);

// I/O Interface from/to controller
input              clk_i;
input              rst_i;
input    [3:0]     addr_i;
input    [24:0]    tag_i;
input    [255:0]   data_i;
input              enable_i;
input              write_i;

output   [24:0]    tag_o;
output   [255:0]   data_o;
output             hit_o;


// Memory
reg      [24:0]    tag [0:15][0:1];//valid, dirty, tag   
reg      [255:0]   data[0:15][0:1];//2^5bytes * 8bits

integer            i, j;


// Write Data      
// 1. Write hit
// 2. Read miss: Read from memory
always@(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        for (i=0;i<16;i=i+1) begin
            for (j=0;j<2;j=j+1) begin
                tag[i][j] <= 25'b0;
                data[i][j] <= 256'b0;
            end
        end
    end
    if (enable_i && write_i) begin
        // TODO: Handle your write of 2-way associative cache + LRU here (0->recent)
        //write hit
        if((tag[addr_i][0][22:0] === tag_i[22:0]) & (tag[addr_i][0][24] === 1'b1)) begin
            data[addr_i][0] <= data_i;
            tag[addr_i][0] <= tag_i;
        end
        else if((tag[addr_i][1][22:0] === tag_i[22:0]) & (tag[addr_i][1][24] === 1'b1)) begin
            data[addr_i][1] <= data[addr_i][0]; //change position
            tag[addr_i][1] <= tag[addr_i][0];   //change position
            data[addr_i][0] <= data_i;          //write in new data
            tag[addr_i][0] <= tag_i;            //change position
        end
        //read miss
        else begin
            data[addr_i][1] <= data[addr_i][0]; //change position
            tag[addr_i][1] <= tag[addr_i][0];   //change position
            data[addr_i][0] <= data_i;          //write in new data
            tag[addr_i][0] <= tag_i;            //change tag
        end
    end
end

// Read Data      
// TODO: tag_o=? data_o=? hit_o=?
assign hit_o = ((tag[addr_i][0][22:0] === tag_i[22:0]) & (tag[addr_i][0][24] === 1'b1)) | ((tag[addr_i][1][22:0] === tag_i[22:0]) & (tag[addr_i][1][24] === 1'b1));
assign tag_o = (tag[addr_i][0][22:0] === tag_i[22:0]) ? tag[addr_i][0] : tag[addr_i][1]; //if both don't hit, treated the same as the 2nd is hit.
assign data_o = (tag[addr_i][0][22:0] === tag_i[22:0]) ? data[addr_i][0] : data[addr_i][1];

endmodule
