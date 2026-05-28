package fit.hcmuaf.edu.vn.util;

import java.util.*;

public class GoLogic {
    private int[][] board;
    private int size;
    
    public GoLogic(int size) { this.size = size; }
    public void setBoard(int[][] board) { this.board = board; }
    
    // Tìm nhóm quân cùng màu
    public List<int[]> findGroup(int x, int y, int color) {
        List<int[]> group = new ArrayList<>();
        boolean[][] visited = new boolean[size][size];
        Queue<int[]> queue = new LinkedList<>();
        queue.add(new int[]{x, y});
        visited[x][y] = true;
        
        while (!queue.isEmpty()) {
            int[] curr = queue.poll();
            group.add(curr);
            int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};
            for (int[] d : dirs) {
                int nx = curr[0] + d[0], ny = curr[1] + d[1];
                if (nx >= 0 && nx < size && ny >= 0 && ny < size && !visited[nx][ny] && board[nx][ny] == color) {
                    visited[nx][ny] = true;
                    queue.add(new int[]{nx, ny});
                }
            }
        }
        return group;
    }
    
    // Đếm số hơi thở của nhóm
    public int countLiberties(List<int[]> group) {
        Set<String> liberties = new HashSet<>();
        for (int[] s : group) {
            int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};
            for (int[] d : dirs) {
                int nx = s[0] + d[0], ny = s[1] + d[1];
                if (nx >= 0 && nx < size && ny >= 0 && ny < size && board[nx][ny] == 0)
                    liberties.add(nx + "," + ny);
            }
        }
        return liberties.size();
    }
    
    // Kiểm tra luật Suicide
    public boolean isSuicide(int x, int y, int color) {
        board[x][y] = color;
        List<int[]> group = findGroup(x, y, color);
        int liberties = countLiberties(group);
        boolean capturesOpponent = false;
        int opponent = (color == 1) ? 2 : 1;
        int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};
        for (int[] d : dirs) {
            int nx = x + d[0], ny = y + d[1];
            if (nx >= 0 && nx < size && ny >= 0 && ny < size && board[nx][ny] == opponent) {
                if (countLiberties(findGroup(nx, ny, opponent)) == 0) { capturesOpponent = true; break; }
            }
        }
        board[x][y] = 0; // Hoàn tác
        return liberties == 0 && !capturesOpponent;
    }
    
    // Tính điểm Area Scoring (Luật Trung Quốc)
    public Map<String, Double> calculateFinalScore(double komi) {
        double b = 0, w = komi;
        boolean[][] visited = new boolean[size][size];
        for (int i = 0; i < size; i++) {
            for (int j = 0; j < size; j++) {
                if (board[i][j] == 1) b++;
                else if (board[i][j] == 2) w++;
                else if (!visited[i][j]) {
                    List<int[]> area = new ArrayList<>();
                    int owner = getAreaOwner(i, j, visited, area);
                    if (owner == 1) b += area.size();
                    else if (owner == 2) w += area.size();
                }
            }
        }
        Map<String, Double> res = new HashMap<>();
        res.put("black", b); res.put("white", w);
        return res;
    }
    
    private int getAreaOwner(int x, int y, boolean[][] visited, List<int[]> area) {
        Queue<int[]> q = new LinkedList<>();
        q.add(new int[]{x, y});
        visited[x][y] = true;
        Set<Integer> neighbors = new HashSet<>();
        while (!q.isEmpty()) {
            int[] c = q.poll(); area.add(c);
            int[][] dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}};
            for (int[] d : dirs) {
                int nx = c[0] + d[0], ny = c[1] + d[1];
                if (nx >= 0 && nx < size && ny >= 0 && ny < size) {
                    if (board[nx][ny] == 0 && !visited[nx][ny]) { visited[nx][ny] = true; q.add(new int[]{nx, ny}); }
                    else if (board[nx][ny] != 0) neighbors.add(board[nx][ny]);
                }
            }
        }
        return (neighbors.size() == 1) ? neighbors.iterator().next() : 0;
    }
    
    public boolean isSameState(int[][] s1, int[][] s2) {
        for(int i=0; i<size; i++) if(!Arrays.equals(s1[i], s2[i])) return false;
        return true;
    }
}