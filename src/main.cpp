#include <iostream>
#include <string>
#include <fstream>
#include <sstream>
#include <cstdlib>
#include<csignal>
using namespace std;

int main() {
    string input;
    string last_input;
    ofstream outFile("kubsh_history.txt");
    signal(SIGHUP,[](int){
            cout<<"\nConfiguration reloaded"<<endl;
        });
    while(true) {
        cout << "$ ";
        last_input = input;
        if (!getline(cin, input)) {
            outFile<<input<<endl;
            if (cin.eof()) {
                if (!last_input.empty()) {
                    cout << last_input << endl;
                }
                cout << "Exit by Ctrl+D" << endl;
            }
            break;
        }
        
        if (input == R"(\q)" || input == "exit 0") {
            cout << input << endl;
            return 0;
        }


        
        if(input.find(R"(\e)")==0)
        {
            string var=input.substr(4);
            if(const char *value=getenv(var.c_str())){
                stringstream ss(value);
                string part;
                for(int i=1;getline(ss,part,':');i++)
                cout<<i<<". "<<part<<endl;
            }
        }

        if (input.find("echo") == 0) {
            if (input.length() > 4) {
                cout << input.substr(5) << endl;
            } else {
                cout << endl;
            }
        }
         if (input.find("type") == 0) {
            if (input.find("echo") != string::npos) {
                cout << "echo is a shell builtin" << endl;
            } 
            if (input.find("exit") != string::npos) {
                cout << "exit is a shell builtin" << endl;
            }
        }

    }
    outFile.close();
    return 0;
}


