/*******************************************************************************
 * Name        : shortestpaths.cpp
 * Author      : Matthew Luzzi and William Newstad
 * Version     : 1.0
 * Date        : 12/6/22
 * Description : Finds the Shortest Path from each vertex to all other vertices using Floyd's Algorithm
 * Pledge      : I pledge my honor that I have abided by the Stevens Honor System.
 ******************************************************************************/

#include <iostream>
#include <iomanip>
#include <fstream>
#include <vector>
#include <sstream>
// #include <string>

using namespace std;

long INF = 9223372036854775807;

/**
 * @brief Converts a long double into an int
 * 
 * @param in 
 * @return int 
 */
int len(long double in) {
    return to_string(static_cast<long int>(in)).length();
}

/**
 * @brief Builds the distance matrix from the adjacency list
 * 
 * @param adjL 
 * @param al_size 
 * @return long** 
 */
long** build_distM(vector<string> &adjL, int al_size) {
    int n = stoi(adjL[0]);
    long** D = new long*[n];
    int curr;
    int curr2;
    for (int i = 0; i < n; i++) {
        D[i] = new long[n];
        for (int j = 0; j < n; j++) {
            if (i == j) {
                D[i][j] = 0;
            }
            else {
                D[i][j] = INF;
            }
        }
    }
    for (size_t k = 1; k < adjL.size(); k++) {
        curr = (int(adjL[k].at(0))) - 65;
        curr2 = (int(adjL[k].at(2))) - 65;
        D[curr][curr2] = stol(adjL[k].substr(4,adjL[k].length()-4));
    }
    return D;
}


/**
 * Implements Floyd’s algorithm for the all-pairs shortest-paths problem. Returns the path lengths matrix and modifies the intermediate vertices matrix
 */
long** build_M(long** &D, long** &P, long** &I, int &n) {
// D ← W //is not necessary if W can be overwritten
    for (int a = 0; a < n; a++) {
        P[a] = new long[n];
        I[a] = new long[n];
        for (int b = 0; b < n; b++) {
            P[a][b] = D[a][b];
            I[a][b] = INF;
        }
    }

    for (int k = 0; k < n; k++) {
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (P[i][k] == INF) { // to prevent overflow
                    continue;
                }
                else if (P[k][j] == INF) {
                    continue;
                }
                else if (min(P[i][j], P[i][k] + P[k][j]) == P[i][j]) {
                    P[i][j] = min(P[i][j], P[i][k] + P[k][j]);
                }
                else {
                    P[i][j] = P[i][k] + P[k][j];
                    I[i][j] = k;
                }
            }
        }
    }
    return P;
}

void get_path(long** &path, int i, int j){
    if (path[i][j] == INF){
        cout << " -> " << char(j+65);
        return;
    }
    else {
        get_path(path, i, path[i][j]);
        get_path(path, path[i][j], j);
    }
}

/**
 * @brief Displays the path details
 * 
 * @param path 
 * @param int_v 
 * @param n 
 */
void display_paths(long** &path, long** &int_v, int &n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            // tmp = j;
            if (path[i][j] == INF) {
                cout << char(i+65) << " -> " << char(j+65) << ", distance: infinity, path: none";
            }
            else {
                cout << char(i+65) << " -> " << char(j+65) << ", distance: " << path[i][j] << ", path: " << char(i+65);
                if (i != j) {
                    get_path(int_v, i, j);
                }
            }
            cout << endl;
        }
    }
}

/** 
 * Displays the matrix on the screen formatted as a table. 
 */ 
void display_table(long** matrix, const string &label, int num_vertices,
                   const bool use_letters = false) {  
    cout << label << endl; 
    long max_val = 0; 
    for (int i = 0; i < num_vertices; i++) { 
        for (int j = 0; j < num_vertices; j++) { 
            long cell = matrix[i][j]; 
            if (cell < INF && cell > max_val) { 
                max_val = matrix[i][j]; 
            } 
        } 
    } 

    int max_cell_width = use_letters ? len(max_val) : 
     len(max(static_cast<long>(num_vertices), max_val));  
    cout << ' '; 
    for (int j = 0; j < num_vertices; j++) { 
        cout << setw(max_cell_width + 1) << static_cast<char>(j + 'A'); 
    } 
    cout << endl; 
    for (int i = 0; i < num_vertices; i++) { 
        cout << static_cast<char>(i + 'A'); 
        for (int j = 0; j < num_vertices; j++) { 
            cout << " " << setw(max_cell_width); 
            if (matrix[i][j] == INF) { 
                cout << "-"; 
            } else if (use_letters) { 
                cout << static_cast<char>(matrix[i][j] + 'A'); 
            } else { 
                cout << matrix[i][j]; 
        } 
    } 
    cout << endl; 
  } 
  cout << endl; 
} 

int main(int argc, const char *argv[]) {
    // Make sure the right number of command line arguments exist.
    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " <filename>" << endl;
        return 1;
    }
    // Create an ifstream object.
    ifstream input_file(argv[1]);
    // If it does not exist, print an error message.
    if (!input_file) {
        cerr << "Error: Cannot open file '" << argv[1] << "'." << endl;
        return 1;
    }
    // Add read errors to the list of exceptions the ifstream will handle.
    input_file.exceptions(ifstream::badbit);
    string line;
    istringstream iss;
    int num_v;
    vector<string> adj;

    try {
        unsigned int line_number = 1;
        string s; // temporary for error checking
        string inp;
        int x;
        while (getline(input_file, line)) {
            if (line_number == 1) {
                iss.str(line);
                if (!(iss >> num_v) || (num_v < 1) || (num_v > 26)) {
                    cerr << "Error: Invalid number of vertices \'" << line << "\' on line 1." << endl;
                    return 1;
                } 
                iss.clear();
            }
            else {
                if (line.length() < 5) {
                    cerr << "Error: Invalid edge data \'" << line << "\' on line " << line_number << "." << endl;
                    return 1;
                }
                int start_idx = 0;

                int curr_idx = 0;
                int len = 0;
                while (line.at(curr_idx) != ' '){
                    curr_idx++;
                    len++;
                }
                char curr = line.at(start_idx);
                if (int(curr)-65 >= num_v || len > 1) {
                    cerr << "Error: Starting vertex \'" << line.substr(start_idx,len) << "\' on line " << line_number << " is not among valid values A-" << char((num_v+16)+'0') << "." << endl;
                    return 1;
                }

                len = 0; // reset length
                curr_idx++;
                start_idx = curr_idx; // start index now at second vertex
                while (line.at(curr_idx) != ' ') {
                    curr_idx++;
                    len++;
                }
                curr = line.at(start_idx);
                if (int(curr)-65 >= num_v || int(curr)-65 < 0 || len > 1) {
                    cerr << "Error: Ending vertex \'" << line.substr(start_idx, len) << "\' on line " << line_number << " is not among valid values A-" << char((num_v+16)+'0') << "." << endl;
                    return 1;
                }

                // len = 0 length no longer used
                curr_idx++;
                start_idx = curr_idx; // start idx now at weight
                iss.str(line.substr(start_idx, line.length()));
                if (!(iss >> x) || (x <= 0)) {
                    cerr << "Error: Invalid edge weight \'" << line.substr(start_idx, line.length()) << "\' on line " << line_number << "." << endl;
                    return 1;
                }
                iss.clear();
            }
            // cout << line_number << ":\t" << line << endl; display adjacency list
            ++line_number;
            adj.push_back(line);
        }
        input_file.close();
    } catch (const ifstream::failure &f) {
        cerr << "Error: An I/O error occurred reading '" << argv[1] << "'.";
        return 1;
    }
    long** D = build_distM(adj,adj.size());
    long** P = new long*[num_v];
    long** I = new long*[num_v];
    build_M(D, P, I, num_v);
    display_table(D, "Distance matrix:", num_v);
    display_table(P, "Path lengths:", num_v);
    display_table(I, "Intermediate vertices:", num_v, true);
    display_paths(P,I,num_v);
    for (int i = 0; i < num_v; i++) {
        delete[] D[i];
        delete[] P[i];
        delete[] I[i];
    } 
    delete[] D;
    delete[] P;
    delete[] I;
    return 0;
}
