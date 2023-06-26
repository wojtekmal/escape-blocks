#include <bits/stdc++.h>
#define x first
#define y second
#define all(x) x.begin(), x.end()
#define pii std::pair<int, int>
#define now() std::chrono::high_resolution_clock::now()
#define gettime(begin, end) (std::chrono::duration_cast<std::chrono::milliseconds>(end - begin).count())
#define svec std::vector<std::string>

#include "board.h"
#include "levels.h"

#pragma GCC optimize("unroll-loops")

std::set<Board> finishedBoards;
std::mt19937 ran(100);

double interestingness(std::string w)
{
    double result = 1;
    result += (w[0] == 'U');

    if (w == "NIE MA" || w == "")
        return -INFINITY;

    for (int i = 1; i < w.size(); i++)
    {
        result += (w[i] == 'U');
        result += (w[i - 1] != w[i]);
    }

    return w.size() < 13 ? 0 : result / log2(w.size());
    return w.size();
}

Board longest_solution(int size, int xd)
{
    svec map;
    Board longest, current;
    std::string longest_result = "";

    map.resize(size, std::string(size, '#'));

    while (xd--)
    {
        for (int x = 0; x < size; x++)
        {
            for (int y = 0; y < size; y++)
            {
                char tile = ran() % 4;
                if (tile == 0)
                {
                    map[y][x] = '#';
                }
                else if (tile == 1)
                {
                    map[y][x] = 'B';
                }
                else
                {
                    map[y][x] = ' ';
                }
            }
        }

        pii meta = {ran() % size, ran() % size};
        pii player = {ran() % size, ran() % size};
        while (meta == player)
            player = {ran() % size, ran() % size};

        map[meta.y][meta.x] = 'M';
        map[player.y][player.x] = 'P';

        current.load_board(map, 0);
        std::string result = current.solve(0);
        if (interestingness(result) > interestingness(longest_result))
        {
            longest = current;
            longest_result = result;
        }

        if (xd % 100 == 1)
        {
            current.print();
            std::cout << result << " " << xd << "\n";
        }
    }
    return longest;
}

std::map<svec, std::string> boardBase;
std::map<Board, std::string> multiBoards;

std::pair<svec, std::string> gen_new_Board(int size)
{
    svec map;
    map.resize(size, std::string(size, '#'));

    while (true)
    {
        for (int x = 0; x < size; x++)
        {
            for (int y = 0; y < size; y++)
            {
                char tile = char(ran() % 5);
                if (tile)
                {
                    map[y][x] = ' ';
                }
                else
                {
                    map[y][x] = '#';
                }
            }
        }

        pii meta = {ran() % size, ran() % size};
        map[meta.y][meta.x] = 'M';

        Board newBoard(map, false);
        // newBoard.noprint = true;

        pii direction[4] = {
            {0, 1},
            {1, 0},
            {0, -1},
            {-1, 0},
        };

        std::set<pii> poses;
        std::vector<std::vector<bool>> us(size, std::vector<bool>(size));
        std::queue<pii> Q;
        Q.push(meta);
        poses.insert(meta);
        us[meta.y][meta.x] = true;

        while (!Q.empty())
        {
            pii pos = Q.front();
            Q.pop();

            for (auto d : direction)
            {
                pii next = {pos.x + d.x, pos.y + d.y};
                if (next.x < 0 || size <= next.x || next.y < 0 || size <= next.y)
                    continue;
                us[next.y][next.x] = true;
                if (map[next.y][next.x] == '#' || poses.count(next))
                    continue;
                poses.insert(next);
                Q.push(next);
            }
        }

        for (int x = 0; x < size; x++)
        {
            for (int y = 0; y < size; y++)
            {
                if (!us[y][x])
                    map[y][x] = ' ';
            }
        }


        poses.erase(meta);
        if(poses.size() < size)
            continue;
        // std::cout << poses.size() << "\n";
        // sleep(1);
        
        int aa = size;
        while (poses.size() && aa--)
        {
            uint r = ran() % poses.size();
            auto it = std::begin(poses);

            std::advance(it, r);

            map[it->y][it->x] = 'B';

            newBoard.load_board(map);
            newBoard.update(true, false);
            // newBoard.print();
            // std::cout << it->x << " " << it->y << "\n";
            
            poses.erase(*it);

            std::string result = newBoard.multisolve(0);
            // std::cout << result << "\n";
            // usleep(1.5 * 1e6);
            
            if (result != "NIE MA")
            {
                if(result.size() != 0 && size / 2 < result.size())
                    return {newBoard.getmap(), result};
                else
                    break;
            }
        }

    }
}

void multisolutions(int size, int xd)
{
    svec multimap;
    multimap.resize(size * 2 + 1, std::string(size + 1, '#'));
    std::for_each(multimap.begin(), multimap.end(), 
        [size](std::string &s){s.resize(size * 2 + 1, ' '); });

    while (xd--)
    {
        std::pair<svec, std::string> newBoard = gen_new_Board(size);
        std::string result = newBoard.second;
        svec current = newBoard.first;

        if (boardBase.count(current) || 12 < result.size())
            continue;

        if (xd % 1 == 0)
        {
            Board(current).print();
            std::cout << result << " " << xd << "\n";
            // sleep(2);
        }

        for (int x = 0; x < size; x++)
        {
            for (int y = 0; y < size; y++)
            {
                multimap[x][y] = current[x][y];
            }
        }

        for (auto [b, r] : boardBase)
        {
            if (r == result)
                continue;

            for (int x = size + 1; x < size * 2 + 1; x++)
            {
                for (int y = 0; y < size; y++)
                {
                    multimap[x][y] = b[x - size - 1][y];
                }
            }

            Board multiboard(multimap);
            std::string multiresult = multiboard.multisolve(0);
            if (multiresult.size() == 0 || multiresult == "NIE MA")
                continue;

            if (multiresult.size() > r.size() + result.size())
            {
                multiboard.print();

                // multiBoards[multiboard] = r + " " + result + "\n" + multiresult;
                multiBoards[multiboard] = multiresult;
                std::cout << multiresult << "\a\n";
                // sleep(100);
            }
        }

        boardBase[current] = result;
    }
}

int main()
{
    auto begin = now();
    int size = 7;
    multisolutions(size, 20);
    auto end = now();

    std::cout << multiBoards.size() << "\n";
    std::cout << gettime(begin, end) << "MS\n\n";

    for(auto brd : multiBoards)
    {
        std::cout << size + 6 << " " << size * 2 + 1 << "\n";
        Board brdc = brd.first;
        brdc.cls = false;
        brdc.print(0);
        std::cout << brd.second.size() << " " << brd.second << "\n\n"; 
    }

    // auto begin = now();
    // Board brd(lvls::test);
    // std::string result = brd.multisolve(2);
    // auto end = now();

    // std::cout << result << "\n";
    // std::cout << gettime(begin, end) << "MS\n";

    // auto begin = now();
    // Board board = longest_multisolution(5, 100);
    // Board boardCopy = board;
    // auto end = now();

    // board.speed = 0.2;
    // std::string result = "board not found";

    // result = board.solve(0);
    // if (board.board.size())
    // {
    //     result = board.multisolve(0);
    //     boardCopy.print();
    // }

    // std::cout << result.size() << " " << interestingness(result) << " " << result << "\n";

    // // Board board;
    // // board.load_board(lvls::map3);
    // // board.load_board(lvls::map7);
    // // board.load_board(lvls::map5);

    // // std::string result = board.multisolve(1, false);

    // // board.print();
    // // std::cout << result << "\n";
}

/*
██░░░░░░░░░░██
░░░░░░░░██░░░░
████░░░░░░░░░░
[]░░██████░░░░
██░░░░░░██████
░░░░░░░░░░██░░
░░░░[][]██░░░░

  ##
#M  
    
   B

██[]░░░░██
░░██[]░░░░
[]██[]░░██
░░M░██[]██
██░░░░M░██

#B  #
 #B
B#  #
 M#B#
#  M#


░░░░[]██
[][M[]██
/\[][][]
██[][][]
LLRRRLLLLLLLRRRLLLLLLLRRRLLLLLLLRRRLLLLLLLRRRLLLLLLLRRRLLR

░░░░░░░░░░██
██████░░░░██
░░░░██[]░░██
[]██████░░░░
[]░M░░[]██░░
[]██[]/\░░[]
47 5.9738 URLLRRRRRRLRLLLLRRRRLRLLLRRRLRRRLRRRLLLRLLRLLRR
119624MS


*/
