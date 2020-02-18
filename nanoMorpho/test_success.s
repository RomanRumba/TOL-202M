;;; Comment
;;; Comment
;;; Comment
tests() {
  var big_abc, palli; ;;; Tests functionBody() conditional var case
  
  ;;; tests Name condition 1 i.e if we see NAME and nothing afterwards
  big_abc;
  
  ;;; tests Name condition 2, expr opname expr generation and Litteral
  big_abc = big_abc + 2 ++ big_abc; ;;;
  
  ;;; tests Name condition 3, expr opname expr generation and Litteral
  big_abc1(big_abc, 2 * 2 ++palli);
  
  ;;; test return expr, ( expr ), expr opname expr and litteral
  return (big_abc * 2);
  
  ;;; test OPNAME expr, return expr, (expr)
  * return(palli);
  
  ;;; testing single Litteral
  222;
  
  ;;; test while(expr) and multiple expr in body
  while( k == 3) {
     big_abc = 2 + k;
	 ++k;
  };
  
  ;;; test if(expr) body, else if(expr) body, else if(expr) body, else(expr) body
  if(k == 3 * 2) {
     big_abc = 2 + k;
	 ++k;
  }
  elsif(3==2){
	big_abc = 2 + k;
	 ++k;
  }
  elsif(3==2){
	big_abc = 2 + k;
	 ++k;
  }
  else{
    big_abc = 2 + k;
	 ++k;
  };
  
   ;;; test ( expr ) , expr opname expr generation
  (palli * 2) * (big_abc + 2);
}
;;; will also test multiple functions in one file
realworldtest(arg) {
  ;;; 2 variables to store values in
  var variable1, variable2;
  
  if(arg == 1)
  {
	variable1 = 1;
	variable2 = variable1 * 10;
  }
  elsif(arg == 2)
  {
    variable1 = 2;
	variable2 = variable1 * 10;
  }
  else
  {
    return false;
  };
  
  while(variable2 > variable1)
  {
	variable1 = (variable1 * 2) + variable2;
	variable2 = variable2 - 1;
  };
  
  return variable1;
}










