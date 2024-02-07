#include <mega32a.h>
#include <delay.h>
#include <stdio.h>
#include <alcd.h>
#define xtal 8000000

char setting(void);
char in_out_search(void);
char time_set(void);
char reserve_park(void);
char set_data(void);
signed char capa=100;
signed char _res=0;
unsigned int n_vurud,n_khuruj;  // maximum  65535  mashin dar ruz 
eeprom unsigned int  vurud_stat[31],khuruj_stat[31]; 
eeprom unsigned char i;
bit _full=0,_emp=0;
signed char minute=58,hour=23,second=50,day=1,month=3;
signed int year=1394;
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
    {

      if(second==59){
      second=0;
      if(minute==59){
      minute=0;
      if(hour==23){
      hour=0;
      day++;
      }
      else
      hour++;
      }
      else
      minute++;
      }
      else
      second++; 
      
      if((day>30) & (month>6)){
      day=1;
      month++;
      }  
        
      if((day>31) & (month<=6)){
      day=1;
      month++;
      }    
      
      if((day>29) & (month==12)){
      day=1;
      month++;
      }
      
      if(month>12){
      month=1;
      year++;
      }
      
      
      
     } 

interrupt [EXT_INT0] void ext_int0_isr(void)
{
capa++;
n_khuruj++;

   if((capa+_res)>=100){
   capa=100-_res;
   _emp=1;
   }
   else{
   _emp=0;
   }    
   
    
     if((capa)<=0){
    capa=0;
    _full=1;
    }
    else{
    _full=0;
  
    }
    
}


interrupt [EXT_INT1] void ext_int1_isr(void)
{
capa--;
n_vurud++;   
    if((capa)<=0){
    capa=0;
    _full=1;
    }
    else{
    _full=0;
    }    
    
   if((capa+_res)>=100){
   capa=100-_res;
   _emp=1;
   }
   else{
   _emp=0;
   } 
   

}

void main(void){

char buff[17],buff2[17];



//GICR|=0xC0;
//MCUCR=0x0A;
//MCUCSR=0x00;
//GIFR=0xC0;

GICR|=0xC0;
MCUCR=0x0B;
MCUCSR=0x00;
GIFR=0xC0;
 

 
lcd_init(16);
lcd_clear();
lcd_putsf("Melec.ir");
lcd_gotoxy(0,1);
lcd_putsf("Parking ABC ");
delay_ms(300);






  ASSR=0x08;//timer2
  TCCR2=0x05;
  TCNT2=0x00;
  OCR2=0x00;  
  TIMSK=0x40;
  
  PORTA=(1<<DDD0)|(1<<DDD1)|(1<<DDD2)|(1<<DDD3)|(1<<DDD4);
  
  
 day=i;   // i in epprom 
 
#asm("sei")
  capa=capa-_res;  
  
    while(1){     
    
           if(PINA.2==0){
           while(PINA.2==0);
           setting();
           }

                     
             if(hour==0 & minute==0 & second==0){  //  data will save   in 0:0:00  
             vurud_stat[i]=n_vurud;
             khuruj_stat[i]=n_khuruj;
             i++; 
                       
                  if(i>30)   // 30 31 29 yek mah 
                  i=0;
                          
                while(hour==0 & minute==0 & second==0){
                lcd_clear();
                lcd_putsf("saving data");
                }
             } 
     
    
     
             sprintf(buff,"Z=%d %d/%d/%d",capa,year,month,day);
             sprintf(buff2,"%d:%d:%d  R=%d ",hour,minute,second,_res);

            lcd_clear(); 

            lcd_puts(buff); 
          
            if(_full==1){
            
            lcd_putsf(" Full");
             } 
          
            if(_emp==1){
           
            lcd_putsf(" Emp");
            }  
                
            lcd_gotoxy(0,1);
            lcd_puts(buff2); 
            delay_ms(25);
  }
} 

/// Functions 4 setting and...

char setting(void){
char _chose=0;
        while(1){
            if(_chose==0){
            lcd_clear();
            lcd_putsf("Time Setting >>");
            }  
            
            if(_chose==1){
            lcd_clear();
            lcd_putsf("IN&OUT Search >>");
            }
        
            if(_chose==2){
            lcd_clear();
            lcd_putsf("Reserve_Park >>");
            }   
            
            if(_chose==3){
            lcd_clear();
            lcd_putsf("Set data >>");
            } 
            
            
             if(PINA.3==0){ //NEXT
             while(PINA.3==0);
             _chose++;  
                 if(_chose>=4)
                 _chose=0;
                }    
              
             
              if(PINA.4==0){ //Back   
              while(PINA.4==0);
              return 0; 
              }    
              
           if(PINA.2==0 & _chose==0 ){  //chose time_setting 
           while(PINA.2==0);
           time_set();
           }            
           
           if(PINA.2==0 & _chose==1 ){  //chose in_out_search
           while(PINA.2==0);
           in_out_search();
           } 
           
           if(PINA.2==0 & _chose==2 ){  //chose reserve
           while(PINA.2==0);
           reserve_park();
           } 
           
           if(PINA.2==0 & _chose==3 ){  //chose set data
           while(PINA.2==0);
           set_data();
           }
  

              
       delay_ms(25);
       }
}

///Time setting 

char time_set(void){
bit _chose=0;
char buff[17];
 while(1){ 

        if(_chose==0){  
        sprintf(buff,"Set min=%d  >",minute);
        lcd_clear();
        lcd_puts(buff);
        
        }    
        
         if(_chose==1){
        sprintf(buff,"Set hour=%d  >",hour);
        lcd_clear();
        lcd_puts(buff);
        
        }       
        
         if(PINA.1==0 & _chose==0){ //UP     min
         while(PINA.1==0);
         minute++;  
         if(minute>59)
         minute=0;
         } 
         
         if(PINA.0==0& _chose==0){ //DOWN    min
         while(PINA.0==0);
         minute--; 
         if(minute<0)
         minute=59;
         } 
         
         if(PINA.1==0 & _chose==1){ //UP    hour
         while(PINA.1==0);
         hour++; 
         if(hour>23)
         hour=0;
         } 
         
         if(PINA.0==0& _chose==1){ //DOWN    hour
         while(PINA.0==0);
         hour--;
         if(hour<0)
         hour=23;
         }       
         
         
        
        
        
        if(PINA.3==0){ //NEXT
             while(PINA.3==0);
           _chose=!_chose;  
             }  
        
        


        if(PINA.4==0){ //Back   
         while(PINA.4==0);
         return 0; 
         } 
         
         delay_ms(25);
 }
}

///IN&OUT Search
 char in_out_search(void){
  char t_month=month,buff[17],buff2[17];  
  char i_temp=i;
  bit bit_m=0;
    while(1){    
         
    
    
            
          
        if(PINA.1==0){ //UP   
         while(PINA.1==0);
         i_temp++; 
         
           if(i_temp>i & bit_m==0){
            i_temp=i;
            t_month--;
            bit_m=1;  
           
           }    
           
           
            if(t_month<=6 & i_temp>31 & bit_m==1){
            i_temp=1;        
            t_month++;
            bit_m=0;  
            }  
            
             if(t_month>6 & i_temp>30 & bit_m==1){
            i_temp=1;        
            t_month++;
            bit_m=0;  
            }
            
             if(t_month==12 & i_temp>29 & bit_m==1){
            i_temp=1;        
            t_month++;
            bit_m=0;  
            } 
            
           if(t_month==0)
           t_month=12;
            
           if(t_month>12)
           t_month=1;
                     
     
         }  
         
  
         
         
                       
         
         if(PINA.0==0){ //DOWN   
         while(PINA.0==0);
         i_temp--;
                                    
         
            if(i_temp==0 & bit_m==0){  
            
            
                t_month--;
                
                if(t_month==0)
                t_month=12;
                
                 if(t_month>12)
                 t_month=1;
                
                if(t_month<=6)
                i_temp=31; 
                
                if(t_month>6)
                i_temp=30; 
                
                if(t_month==12)
                i_temp=29;
            
            
            
            bit_m=1;
            } 
            
            if(i_temp<i & bit_m==1 ){
            i_temp=i;
            t_month++;
            bit_m=0;
            }   
            
           if(t_month==0)
           t_month=12; 
           
            if(t_month>12)
           t_month=1;
            
         }  
         
          
         
       
                           
         
         sprintf(buff,"%d/%d/%d ",year,t_month,i_temp); 
         sprintf(buff2,"in=%d out=%d",vurud_stat[i_temp],khuruj_stat[i_temp]);   
         
         lcd_clear();
         lcd_puts(buff); 
         lcd_gotoxy(0,1);
         lcd_puts(buff2);
         
         
         
         if(PINA.4==0){ //Back   
         while(PINA.4==0);
         return 0; 
         }   
     delay_ms(25);
     }
}

//reserve_park

char reserve_park(void){
   char buff[17];
   
 while(1){ 
   sprintf(buff,"Reserved=%d",_res);
   lcd_clear();
   lcd_puts(buff);
   
         if(PINA.1==0){ //UP   
         while(PINA.1==0);
         _res++; 
         }   
         
          if(_res>=100){
         _res=99;
         }
         
         if(PINA.0==0){ //DOWN   
         while(PINA.0==0);
         _res--;  
         
         }  
    
         if(_res<=0){
         _res=0;
         } 
         

     if(PINA.4==0){ //Back   
     while(PINA.4==0);
     return 0; 
     }
     delay_ms(25);
 }
 
 
}

//// data setting

char set_data(void){
char _chose=0;
char buff[17];
 while(1){ 

        if(_chose==1){  
        sprintf(buff,"Set month=%d  >",month);
        lcd_clear();
        lcd_puts(buff);
        }    
        
         if(_chose==0){
        sprintf(buff,"Set day=%d  >",day);
        lcd_clear();
        lcd_puts(buff);
        }
        
        
        if(_chose==2){  
        sprintf(buff,"Set year=%d  >",year);
        lcd_clear();
        lcd_puts(buff);
        }
               
        
         if(PINA.1==0 & _chose==1){ //UP     month
         while(PINA.1==0);
         month++;  
         if(month>12)
         month=1;
         } 
         
         if(PINA.0==0& _chose==1){ //DOWN    month
         while(PINA.0==0);
         month--; 
         if(month<1)
         month=12;
         } 
         
         if(PINA.1==0 & _chose==0){ //UP    day
         while(PINA.1==0);      
         day++;     
         i=day;
         if(day>31)
         day=1;
         } 
         
         if(PINA.0==0& _chose==0){ //DOWN    day
         while(PINA.0==0);
         day--;  
         i=day;
         if(day<1)
         day=31;
         }     
         
         if(PINA.0==0& _chose==2){ //DOWN    year
         while(PINA.0==0);
         year--;
         if(year<1)
         year=1300;
         } 
         
         if(PINA.1==0 & _chose==2){ //UP    year
         while(PINA.1==0);      
         year++; 
         //if(year>1404)
         //year=0;
         }       
         
         
         
        
        
        
       if(PINA.3==0){ //NEXT
             while(PINA.3==0);
             _chose++;  
                 if(_chose>=3)
                 _chose=0;
                } 
        
        


        if(PINA.4==0){ //Back   
         while(PINA.4==0);
         return 0; 
         } 
         
         delay_ms(25);
 }
}

