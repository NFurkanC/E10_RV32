volatile int debug_out = 0; // to memory

int main() {
    int a = 0;
    int b = 1;
    int next;

   
    for(int i = 0; i < 15; i++) {
        next = a + b;
        a = b;
        b = next;
        
        debug_out = next; 
    }

    return 0; 
}