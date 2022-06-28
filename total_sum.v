module total_sum(a,b,cin,sum,cout);
  input wire a,b, cin;
  output wire sum, cout;
  
  assign sum = a^b^cin;
  assign cout = (a&b)|(a&cin)|(b&cin);
  
 endmodule