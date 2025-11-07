#include <iostream>
#include <string>
#include <fstream>

using namespace std;

const bool testflag = true;
string file;
ofstream outFile;

string trim(const string& str) {
    size_t start = str.find_first_not_of(" \t\n\r");
    size_t end = str.find_last_not_of(" \t\n\r");
    if (start == string::npos || end == string::npos) {
        return "";
    }
    return str.substr(start, end - start + 1);
}

void debug(const string& command) {
    string text = command.substr(5);
    cout << text << endl;
}

void history(const string& command) {
    if (!command.empty() && command != "\\q" && outFile.is_open()) {
        outFile << command << endl;
        outFile.flush();
    }
}

int main() {
    file = ".kubsh_history";
    outFile.open(file, ios::app);
    
    string input;
    
    while(true) {
        if (!testflag) {
            cout << "$ ";
            cout.flush();
        }
        
        if (!getline(cin, input)) {
            break;
        }
        
        string trinput = trim(input);
        
        if (trinput.empty()) {
            continue;
        }
        
        history(trinput);
        
        if (trinput == "\\q") {
            break;
        }
        else if (trinput.find("debug") == 0) {
            debug(trinput);
            if (testflag) break;
        }
        else if (trinput.find("echo") == 0) {
            debug(trinput);
            if (testflag) break;
        }
        else {
            cout << trinput << ": command not found" << endl;
            if (testflag) break;
        }
    }
    
    if (outFile.is_open()) {
        outFile.close();
    }
    
    return 0;
}

