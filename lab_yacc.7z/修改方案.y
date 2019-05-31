运行步骤：
1.     $./build.sh
2.     $yacc生成的y.tab.c中找到 yychar=yylex() ,把yylex()改成getToken()
3.     $make
4.     $./tiny.out 测试文件名(文件包中为sample.tny)





修改文件有：
globals.h
57行    加入ForK,WhileK,ToK


tiny.l
加入
"for"           {return FOR;}
"while"         {return WHILE;}
"endwhile"      {return ENDWHILE;}
"do"            {return DO;}
"enddo"         {return ENDDO;}
"to"            {return TO;}
"mod"		{return MOD;}


tiny.y
22行  加入WHILE ENDWHILE DO ENDDO TO FOR
24行  加MOD
47行  加    | for_stmt { $$ = $1; }
            | while_stmt { $$ = $1; }
            | to_stmt { $$ = $1; }
90行  加	while_stmt  : WHILE exp stmt_seq ENDWHILE
 			 { $$ = newStmtNode(WhileK);
              	     $$->child[0] = $2;
            	       $$->child[1] = $3;
           	      }
          	  ;
		for_stmt    : FOR to_stmt DO stmt_seq ENDDO
			 { $$ = newStmtNode(ForK);
           	        $$->child[0] = $2;
           	        $$->child[1] = $4;
         	        }
         	   ;
		to_stmt     : factor ASSIGN factor TO factor 
			 { $$ = newStmtNode(ToK);
   	                $$->child[0] = $1;
     	              $$->child[1] = $3;
			   $$->child[2] = $5;
     	            }

	            ;
137行 term中加	| term MOD factor
                	 { $$ = newExpNode(OpK);
                	   $$->child[0] = $1;
                	   $$->child[1] = $3;
                	   $$->attr.op = MOD;
                	 }

util.c
25行	加   	case FOR:
    		case WHILE:
    		case ENDWHILE:
    		case TO:
   	 	case DO:
   	 	case ENDDO:
44行 加     case MOD: fprintf(listing,"mod\n"); break;

156行 加
        case ForK:
          fprintf(listing,"For\n");
          break;
        case WhileK:
          fprintf(listing,"While\n");
          break;
        case ToK:
          fprintf(listing,"To: %s\n",tree->attr.name);
          break;


