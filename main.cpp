#include <iostream>
#include <string>

using namespace std;

const bool testflag = true;

void debug(const string& command) {
    string text = command.substr(5);
    cout << text << endl;
}

string trim(const string& str) {
    size_t start = str.find_first_not_of(" \t\n\r");
    size_t end = str.find_last_not_of(" \t\n\r");
    if (start == string::npos || end == string::npos) {
        return "";
    }
    return str.substr(start, end - start + 1);
}


int main() {
    string input;
    string trinput = trim(input);
    
    while(true) {
        if (!testflag) {
            cout << "$ ";
            cout.flush();
        }
        
        if (!getline(cin, input)) {
            break;
        }
        
        if (input.find("debug") == 0) {
            debug(input);
            if (testflag) break;
        }
        
        if (trinput.empty()) {
            continue;
        }
        if (trinput == "\\q") {
             break;
        }
    return 0;
}