class mymdf:
    MAX_X = 0
    MAX_Y = 0
    WALLS = []

    g = 1
    R = []
    U = []

    def __init__(self, map, legal, walls, food_location, ghosts):
        self.getMapLimits(walls)
        self.getCellRewards(walls, food_location, ghosts)

        self.U.append([ [0]*(self.MAX_Y) for i in range(self.MAX_X) ])

        while True:
            u = self.U

            for x in self.MAX_X:
                for y in self.MAX_Y:

                    if [x,y] not in self.WALLS:
                        us = []
                        for i in self.getLegal([x,y]):
                            us = sum([ u[x][y]*a['p'] for a in self.ts([x,y],i) ])
                        self.U[x][y] = self.R[x][y] + self.g * max(us)

            if u == self.U :
                continue

 
    def ts(self, location, direction):
    
        x = location[0]
        y = location[1]

        s = {  
            'West': { 'x': x - 1, 'y': y},
            'East': {'x': x + 1, 'y': y },
            'South': {'x': x, 'y': y - 1 },
            'North': {'x': x, 'y': y + 1}
        }
        left,right = self.getAdjacent(s)
        adj = [left, right]
        [adj.remove(v) for v in adj if [s[v]['x'],s[v]['y']] in self.WALLS]

        move_info = {
            direction : {'p': 1.0-(0.1*len(adj))}
        }
        for k in adj: move_info[k] = {'p': 0.1}

        return move_info

    def getAdjacent(self,direction):
        moves = ['North','East','South','West']

        r_dir = moves.index(direction)+1
        if r_dir > len(moves)-1: r_dir = 0
        
        left = moves[moves.index(direction)-1]
        right = moves[r_dir]
  
        return left, right

    def getLegal(self, location):
        x = location[0]
        y = location[1]
        sa = [{'x': x - 1, 'y': y, 'a': 'West'},
            {'x': x + 1, 'y': y, 'a': 'East'},
            {'x': x, 'y': y - 1, 'a': 'South'},
            {'x': x, 'y': y + 1, 'a': 'North'}]
        
        legal = []
        [legal.append(t['a']) for t in sa if (t['x'],t['y']) not in self.WALLS]

        return legal

    def getMapLimits(self,walls):
        self.WALLS = walls
        for i in walls:
            x = i[0]+1
            y = i[1]+1
            if x>self.MAX_X:
                self.MAX_X = x
            if y>self.MAX_Y:
                self.MAX_Y = y
            print([self.MAX_X,self.MAX_Y])

    def getCellRewards(self,walls,food_location,ghosts):

        for x in range(self.MAX_X):
            line = []
            for y in range(self.MAX_Y):
                if [x,y] in walls: line.append(0)
                if [x,y] in food_location: line.append(10)
                if [x,y] in ghosts: line.append(-10)
            self.R.insert(0,line)
        
