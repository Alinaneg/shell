#include <iostream>
#include <string>

using namespace std;

const bool testflag = true;

void debug(const string& command) {
    string text = command.substr(5);
    cout << text << endl;
}

int main() {
    string input;
    
    if (!testflag) {
        cout << "$ ";
    }
    
    if (!getline(cin, input)) {
        return 0;
    }
    
    if (input.find("debug") == 0) {
        debug(input);
        if (testflag) return 0;
    }
    
    return 0;
}