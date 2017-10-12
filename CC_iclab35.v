module CC (
        in_n0,
        in_n1,
        in_n2,
        in_n3,
        opt,
        out_n0,
        out_n1,
        out_n2,
        out_n3
);

input[3:0]in_n0,in_n1,in_n2,in_n3;
input[1:0]opt;
output reg[3:0]out_n0,out_n1,out_n2,out_n3;
integer out[3:0]; //serve as a temporary storage for output reg
integer i,j,a,t; //i&j serve as a iteration indicator in for loop; a is average;t is temporary variable 

always@*
begin

        if(opt==2)
        begin
                out[0] = in_n3;
                out[1] = in_n2-out[0];
                out[2] = in_n1-out[0];
                out[3] = in_n0-out[0]; 
		out[0]  = 'd0;         //inverse and normalize
                for(i=0; i<4; i=i+1)
                begin
                        if(out[i]<0)
                        begin
                                out[i]=out[i]+'d10; // recover the negative value back to the nuber range of 0-9
                        end
                end

        end

        else if((opt==0) || (opt==1))
        begin
                out[0] = in_n0;
                out[1] = in_n1;
                out[2] = in_n2;
                out[3] = in_n3;

                for(i=3; i>0; i=i-1)
                begin
                        for(j=0; j<i; j=j+1)
                        begin
                                if(out[j] > out[j+1])
                                begin
                                        t = out[j];
                                        out[j] = out[j+1];
                                        out[j+1] = t;
                                end
                        end
                end  //sorting process

                if(opt==1)
                begin
                        out[1] = out[1]-out[0];
                        out[2] = out[2]-out[0];
                        out[3] = out[3]-out[0];
                        out[0] = 'd0;
                        for(i=1; i<4;i=i+1)
                        begin
                                if(out[i]<0)
                                begin
                                        out[i] = out[i]+'d10;
                                end
                        end
                end
                else
                begin
                        a = (out[0]+out[1]+out[2]+out[3])/'d4;
                        out[3] = a;
                end			// for opt=0, the smoothing process
        end

        else  //opt=3
        begin
                out[0] = in_n0;
                out[1] = in_n1;
                out[2] = in_n2;
                out[3] = in_n3;

                a = (out[0]+out[1]+out[2]+out[3])/'d4;

                if(out[3]>=out[2] && out[3]>=out[1] &&out[3]>=out[0])
                begin
                        out[3]=a;
                end
                else if(out[2]>=out[3] && out[2]>=out[1] &&out[2]>=out[0])
                begin
                        out[2]=a;
                end
                else if(out[1]>=out[3] && out[1]>=out[2] &&out[1]>=out[0])
                begin
                        out[1]=a;
                end
                else
                begin
                        out[0]=a;
                end			//use this method to replace for loop to prevent losing time in for loop cycle
					
                for(i=0; i<4; i=i+1)
                begin
                        if(out[i]!=0)
                        begin
                                out[i]= 'd10-out[i];
                                if(out[i]==10)
                                begin
                                        out[i]='d0;  //as our number is ranged from 0-9, number 10 must be revert to 0
                                end
                        end
                end
        end
out_n0 = out[0];
out_n1 = out[1];
out_n2 = out[2];
out_n3 = out[3];
end
endmodule
