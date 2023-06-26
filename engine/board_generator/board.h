#pragma once
#include <bits/stdc++.h>
#define x first
#define y second
#define ll long long
#define all(x) x.begin(), x.end()
#define pii std::pair<int, int>

const int LEFT = 1;
const int RIGHT = -1;
const int UP = 2;
const int FINISH = 2137;

std::map<char, int> dir = {
    {'L', LEFT},
    {'R', RIGHT},
    {'U', UP},
};

std::map<char, int> blocks = {
    {'P', 0},
    {' ', 1},
    {'B', 2},
    {'#', 3},
};

// struct hashFunction
// {
//     size_t operator()(const std::pair<int, std::vector<bool>> &a) const
//     {
//         return a.x ^ (std::hash(a.y));
//     }
// };

class Board
{
private:
    std::vector<bool> id;

    void make_id()
    {
        id.resize(dim.x * dim.y * 3);
        switch (rotation)
        {
        case 0:
            id.push_back(0), id.push_back(0);
            break;
        case 1:
            id.push_back(0), id.push_back(1);
            break;
        case 2:
            id.push_back(1), id.push_back(0);
            break;
        case 3:
            id.push_back(1), id.push_back(1);
            break;
        }

        for (int y = 1; y <= dim.y; y++)
        {
            for (int x = 1; x <= dim.x; x++)
            {
                int blockid = blocks[board[y][x]];
                switch (blockid)
                {
                case 0:
                    id.push_back(0), id.push_back(0);
                    break;
                case 1:
                    id.push_back(1), id.push_back(0);
                    break;
                case 2:
                    id.push_back(0), id.push_back(1);
                    break;
                case 3:
                    id.push_back(1), id.push_back(1);
                    break;
                }
            }
        }
        validID = true;
    }

public:
    std::vector<std::string> board;
    pii dim;
    std::set<pii> finish;
    int rotation = 0;
    double speed = 0.25;
    bool interactive = true;
    bool cls = true;
    bool validID = false;
    int finishRotation = 0;
    int animation = 2;
    pii player = {0, 0};
    bool multimap = false;
    bool noprint = false;

    std::vector<bool> &get_id()
    {
        if (!validID)
            make_id();
        return id;
    }

    void clear()
    {
        if (cls)
            (void)!system("clear");
    }

    void print(int fancy = true)
    {
        if (noprint)
            return;

        clear();

        if (fancy)
        {
            for (int y = 1; y <= dim.y; y++)
            {
                for (int x = 1; x <= dim.x; x++)
                {
                    if (finish.count({x, y}))
                    {
                        std::cout << "\033[1;31;41m";
                    }
                    if (board[y][x] == '#')
                        std::cout << "██";
                    else if (board[y][x] == 'P')
                        std::cout << "/\\";
                    else if (board[y][x] == 'B')
                        std::cout << "[]";
                    else
                        std::cout << "░░";
                    if (finish.count({x, y}))
                    {
                        std::cout << "\033[0;m";
                    }
                }
                std::cout << "\n";
            }
            std::cout << std::flush;
        }
        else if (fancy == 0)
        {
            for (int y = 1; y <= dim.y; y++)
            {
                for (int x = 1; x <= dim.x / 2 + 1; x++)
                {
                    if (finish.count({x, y}))
                    {
                        std::cout << "P";
                    }
                    else
                    {
                        // std::cout << board[y][x];
                        if(board[y][x] == ' ')
                            std::cout << '.';
                        else
                            std::cout << board[y][x];
                    }

                }
                if(y == 1)
                    std::cout << ".#W#.";
                else if(y == 2)
                    std::cout << "##D##";
                else if(y == 3)
                    std::cout << "3DGDE";
                else if(y == 4)
                    std::cout << "##D##";
                else if(y == 5)
                    std::cout << ".#M#.";
                else if(y == 6)
                    std::cout << ".###.";
                else
                    std::cout << ".....";
                std::cout << "\n";
            }
            std::cout << std::flush;
        }
    }

    Board() {}
    Board(std::vector<std::string> p_board, bool p_interactive = false)
    {
        load_board(p_board, p_interactive);
    }

    bool load_board(std::vector<std::string> p_board, bool p_interactive = false)
    {
        interactive = p_interactive;
        finish.clear();
        validID = false;
        dim = {p_board.size(), p_board[0].size()};

        board.resize(dim.y + 2);
        board[0] = (std::string(dim.x + 2, '#'));
        board[dim.y + 1] = (std::string(dim.x + 2, '#'));
        for (int i = 0; i < dim.y; i++)
            board[i + 1] = "#" + p_board[i] + "#";

        for (int y = 1; y <= dim.y; y++)
        {
            for (int x = 1; x <= dim.x; x++)
            {
                if (board[y][x] == 'M')
                {
                    board[y][x] = ' ';
                    finish.insert({x, y});
                }
            }
        }
        if (interactive)
            print();
        return true;
    }

    bool multiCheck()
    {
        for (auto u : finish)
            if (board[u.y][u.x] == ' ')
                return false;
        return true;
    }

    int update(bool instant = false, bool single = true)
    {
        validID = false;
        bool end = true;
        for (int y = dim.y; y >= 0; y--)
        {
            for (int x = 1; x <= dim.x; x++)
            {
                char tile = board[y][x];
                if (tile == 'B' || tile == 'P')
                {
                    int h = y;
                    do
                    {
                        if (single && tile == 'P' && rotation % 4 == finishRotation && finish.count({x, y}))
                        {
                            return FINISH;
                        }
                        if (board[h + 1][x] == ' ')
                        {
                            board[h][x] = ' ';
                            board[++h][x] = tile;
                            if (single && tile == 'P' && rotation == finishRotation && finish.count({x, y}))
                            {
                                return FINISH;
                            }
                        }
                        else
                            break;
                    } while (instant);
                    if (board[h + 1][x] == ' ')
                        end = false;
                }
            }
        }
        if (single)
            std::cout << 2137 << "a\n";
        if (!single && multiCheck())
        {
            // std::cout << "amogus\a\n";
            // sleep(5);
            return FINISH;
        }
        return end;
    }

    bool animate()
    {
        int update_result;
        do
        {
            print();
            usleep(uint(speed * 1000 * 1000));
        } while (!(update_result = update(false)));
        print();
        if (update_result == FINISH)
        {
            std::cout << "FINISH\n";
            return true;
        }
        usleep(uint(speed * 1000 * 1000));
        return false;
    }

    bool rotate(int rotations)
    {
        validID = false;
        rotations = (rotations % 4 + 4) % 4;

        if (rotations == 1)
        {
            std::vector<std::string> boardCopy(dim.x + 2);
            for (int x = 0; x <= dim.x + 1; x++)
            {
                boardCopy[x].resize(dim.y + 2);
            }

            for (int y = 0; y <= dim.y + 1; y++)
            {
                for (int x = 0; x <= dim.x + 1; x++)
                {
                    boardCopy[x][y] = board[y][dim.x - x + 1];
                }
            }
            board = boardCopy;
            std::set<pii> finishCopy;
            for (auto f : finish)
                finishCopy.insert({f.y, dim.x - f.x + 1});
            finish = finishCopy;

            std::swap(dim.x, dim.y);
        }

        if (rotations == 2)
        {
            std::reverse(all(board));
            for (int y = 1; y <= dim.y; y++)
            {
                std::reverse(all(board[y]));
            }
            std::set<pii> finishCopy;
            for (auto f : finish)
                finishCopy.insert({dim.x - f.x + 1, dim.y - f.y + 1});
            finish = finishCopy;
        }

        if (rotations == 3)
        {
            std::vector<std::string> boardCopy(dim.x + 2);
            for (int x = 0; x <= dim.x + 1; x++)
            {
                boardCopy[x].resize(dim.y + 2);
            }

            for (int y = 0; y <= dim.y + 1; y++)
            {
                for (int x = 0; x <= dim.x + 1; x++)
                {
                    boardCopy[x][y] = board[dim.y - y + 1][x];
                }
            }
            board = boardCopy;

            std::set<pii> finishCopy;
            for (auto f : finish)
                finishCopy.insert({dim.y - f.y + 1, f.x});
            finish = finishCopy;

            std::swap(dim.x, dim.y);
        }
        rotation = (rotation + rotations) % 4;

        if (interactive)
        {
            return animate();
        }
        return false;
    }

    std::set<std::vector<bool>> states;

    std::string solveBFS(Board sboard, int limit = INT_MAX, bool single = true)
    {
        std::queue<std::pair<Board, std::string>> Q;
        Q.push({sboard, ""});
        std::string moves;
        while (!Q.empty())
        {
            sboard = Q.front().x;
            moves = Q.front().y;
            if(moves.size() > limit)
                break;
            Q.pop();

            for (auto d : dir)
            {
                Board boardCopy = sboard;
                boardCopy.rotate(d.y);

                if (boardCopy.update(true, single) == FINISH)
                {
                    return moves + d.x;
                }
                if (!states.count(boardCopy.get_id()))
                {
                    Q.push({boardCopy, moves + d.x});
                    states.insert(sboard.get_id());
                }
            }
        }
        return "NIE MA";
    }

    std::map<std::vector<bool>, uint> statesRec;
    std::string resultRec = "";

    void solveRec(Board sboard, std::string moves = "", bool single = true)
    {
        if (resultRec.size() <= moves.size() + 1)
            return;

        // board.print();
        statesRec[sboard.get_id()] = uint(moves.size());

        Board boardL = sboard,
              boardR = sboard,
              boardU = sboard;

        boardL.rotate(LEFT);
        if (boardL.update(true, single) == FINISH)
        {
            if (resultRec.size() > moves.size() + 1)
            {
                resultRec = moves + 'L';
                if (animation)
                    std::cout << resultRec << "\n";
            }
            return;
        }
        if (!statesRec.count(boardL.get_id()) || statesRec[boardL.get_id()] >= moves.size() + 1)
        {
            solveRec(boardL, moves + 'L', single);
        }

        boardR.rotate(RIGHT);
        if (boardR.update(true, single) == FINISH)
        {
            if (resultRec.size() > moves.size() + 1)
            {
                resultRec = moves + 'R';
                if (animation)
                    std::cout << resultRec << "\n";
            }
            return;
        }
        if (!statesRec.count(boardR.get_id()) || statesRec[boardR.get_id()] >= moves.size() + 1)
        {
            solveRec(boardR, moves + 'R', single);
        }

        boardU.rotate(UP);
        if (boardU.update(true, single) == FINISH)
        {
            if (resultRec.size() > moves.size() + 1)
            {
                resultRec = moves + 'U';
                if (animation)
                    std::cout << resultRec << "\n";
            }
            return;
        }
        if (!statesRec.count(boardU.get_id()) || statesRec[boardU.get_id()] >= moves.size() + 1)
        {
            solveRec(boardU, moves + 'U', single);
        }
    }

    bool initialTest(bool multi = false)
    {
        pii start = {0, 0};
        std::queue<pii> Q;
        std::vector<std::vector<bool>> xd(dim.y + 2, std::vector<bool>(dim.x + 2));

        for (int x = 0; x <= dim.x + 1; x++)
        {
            for (int y = 0; y <= dim.y + 1; y++)
            {
                if (board[y][x] == 'P' || (board[y][x] == 'B' && multi))
                {
                    start = {x, y};
                    Q.push(start);
                }
                if (board[y][x] == '#')
                {
                    xd[y][x] = true;
                }
            }
        }
        if (start == std::make_pair(0, 0))
            return 0;

        pii direction[4] = {
            {0, 1},
            {1, 0},
            {0, -1},
            {-1, 0},
        };

        while (!Q.empty())
        {
            pii pos = Q.front();
            Q.pop();
            if (finish.count(pos))
                return true;
            for (int i = 0; i < 4; i++)
            {
                pii next = {pos.x + direction[i].x, pos.y + direction[i].y};
                if (xd[next.y][next.x])
                    continue;
                xd[next.y][next.x] = true;
                Q.push(next);
            }
        }
        return false;
    }

    std::string solve(int p_animation = 2)
    {
        std::string result;
        animation = p_animation;
        double old_speed = speed;

        interactive = (animation >= 2);
        if (animation < 3)
            speed = 0.01;
        uint time = 2137;
        if (update(true) == FINISH)
            result = "";
        else
        {
            auto start = now();

            states.clear();
            if (!initialTest())
                return "NIE MA";
            result = solveBFS(*this);

            auto stop = now();
            time = gettime(start, stop);
        }

        if (animation > 0)
        {
            interactive = true;
            speed = old_speed;
            clear();

            if (result.size() != 0 && result[0] != '#')
            {
                std::cout << "SOLUTION FOUND IN " << time << "MS!\a\n";
                std::cout << result.size() << " " << result << "\n";
            }
            else
            {
                std::cout << "SOLUTION NOT FOUND!\a\n";
                std::cout << ":c\n";
                return "NIE MA";
            }
            sleep(2);

            animate();
            for (auto r : result)
            {
                rotate(dir[r]);
                usleep(uint(speed * 1000 * 1000));
            }
            std::cout << result.size() << " " << result << "\n";

            std::cout << time << "MS\n";
        }
        if (result.size() == 0 || result[0] == '#')
        {
            return "NIE MA";
        }
        return result;
    }

    std::string multisolve(int p_animation = 2)
    {
        std::string result;
        animation = p_animation;
        double old_speed = speed;

        interactive = (animation >= 2);
        if (animation < 3)
            speed = 0.01;
        if (update(true, false) == FINISH)
            result = "";
        else
        {
            states.clear();

            resultRec.assign(21, '#');
            solveRec(*this, "", false);
            result = resultRec;
        }

        if (animation > 0)
        {
            interactive = true;
            speed = old_speed;
            clear();

            if (result.size() != 0 && result[0] != '#')
            {
                std::cout << "SOLUTION FOUND IN " << time << "MS!\a\n";
                std::cout << result.size() << " " << result << "\n";
            }
            else
            {
                std::cout << "SOLUTION NOT FOUND!\a\n";
                std::cout << ":c\n";
                return "NIE MA";
            }
            sleep(2);

            animate();
            for (auto r : result)
            {
                rotate(dir[r]);
                usleep(uint(speed * 1000 * 1000));
            }
            std::cout << result.size() << " " << result << "\n";

            std::cout << time << "MS\n";
        }
        if (result.size() == 0)
            return "";
        if (result[0] == '#')
        {
            return "NIE MA";
        }
        return result;
    }

    svec getmap()
    {
        svec map;
        map.resize(dim.y);
        for (int y = 0; y < dim.y; y++)
        {
            for (int x = 0; x < dim.x; x++)
            {
                map[y].push_back(board[y + 1][x + 1]);
            }
        }
        for (auto f : finish)
        {
            map[f.y - 1][f.x - 1] = 'M';
        }
        return map;
    }
};

bool operator<(const Board &a, const Board &b)
{
    if (a.rotation == b.rotation)
    {
        for (int y = 1; y <= a.dim.y; y++)
        {
            if (a.board[y] != b.board[y])
            {
                return a.board[y] < b.board[y];
            }
        }

        // if(a.validID == false)
        // {
        //     std::cout << "invalid ID\a\n";
        //     sleep(1);
        // }
        // if(b.validID == false)
        // {
        //     std::cout << "invalid ID\a\n";
        //     sleep(1);
        // }
        // return a.id < b.id;
    }
    return a.rotation < b.rotation;
}
