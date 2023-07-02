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
std::mt19937 ran;

std::map<char, int> blocksChances =
    {
        {'#', 33},
        {' ', 33},
        {'B', 33},
        // {},
        // {},
};
int size = 5;

std::pair<svec, std::string> gen_board()
{
    svec map;
    map.resize(size, std::string(size, '#'));

    while (true)
    {
        for (int x = 0; x < size; x++)
        {
            for (int y = 0; y < size; y++)
            {
                int tile = ran() % 100 + 1;
                for (auto [b, c] : blocksChances)
                {
                    tile -= c;
                    if (tile <= 0)
                    {
                        map[y][x] = b;
                        break;
                    }
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

        if(poses.size() < size * sqrt(size))
            continue;

        poses.erase(meta);

        uint r = ran() % poses.size();
        auto it = std::begin(poses);
        std::advance(it, r);

        map[it->y][it->x] = 'G';

        newBoard.load_board(map);
        newBoard.update(true, false);

        std::string result = newBoard.solve();

        if (result == "NIE MA" || (result.size() != 0 && size / 2 < result.size()))
            return {newBoard.getmap(), result};
    }
}

int main(int argc, char** argv)
{
    
    // for (int i = 0; i < argc; ++i)
    //     std::cout << argv[i] << "\n";
    
    ulong seed;
    if(argc > 1)
        size = std::stoul(argv[1]);
    else
        std::cin >> size;
    if(argc > 2)
        seed = std::stoul(argv[2]);
    else
        std::cin >> seed;
    
    ran = std::mt19937(seed);

    auto begin = now();

    std::pair<Board, std::string> res = gen_board();

    Board brdc = res.first;
    // uint hash = std::hash<std::vector<bool>>{}(brdc.get_id());
    
    std::cout << size << " " << size << "\n";

    brdc.cls = false;
    std::cout << brdc.getfile();
    std::cout << res.second.size() << " " << res.second << "\n\n"; 
    

    auto end = now();


    brdc.print();
    std::cerr << gettime(begin, end) << "MS\n\n";
}
