# mdpAgents.py
# parsons/20-nov-2017
#
# Version 1
#
# The starting point for CW2.
#
# Intended to work with the PacMan AI projects from:
#
# http://ai.berkeley.edu/
#
# These use a simple API that allow us to control Pacman's interaction with
# the environment adding a layer on top of the AI Berkeley code.
#
# As required by the licensing agreement for the PacMan AI we have:
#
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
#
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).

# The agent here is was written by Simon Parsons, based on the code in
# pacmanAgents.py

from pacman import Directions
from game import Agent
import api
import random
import game
import util

class MDPAgent(Agent):

    # Constructor: this gets run when we first invoke pacman.py
    def __init__(self):
        print "Starting up MDPAgent!"
        name = "Pacman"

        self.MAX_X = 0
        self.MAX_Y = 0
        self.WALLS = []

        self.P = []         # Policy map
        self.R = []         # Rewards map
        self.U = []         # Utility map
        self.g = 1          # Discount factor


    # Gets run after an MDPAgent object is created and once there is
    # game state to access.
    def registerInitialState(self, state):
        walls = api.walls(state)
        self.WALLS = self.getMapLimits(walls)

        print "Running registerInitialState for MDPAgent!"
        print "I'm at:"
        print api.whereAmI(state)

    # This is what gets run in between multiple games
    def final(self, state):
        print "Looks like the game just ended!"


    # Run value iteration every round and select optimal policy
    def getAction(self, state):
        ghosts = api.ghosts(state)
        capsules = api.capsules(state)
        food_location = api.food(state)
        food_location.extend(capsules)
        pacman = api.whereAmI(state)

        # initialise utility map and set reward positions based on food and ghosts
        self.U = self.initMatrix(self.MAX_X,self.MAX_Y)
        self.P = self.initMatrix(self.MAX_X,self.MAX_Y)
        self.R = self.getCellRewards(self.WALLS, food_location, ghosts, pacman)


        # Get the actions we can try, and remove "STOP" if that is one of them.
        legal = api.legalActions(state)

        if Directions.STOP in legal:
            legal.remove(Directions.STOP)

        # perform value iteration and select optimal policy from legal directions
        self.valueIteration()
        # self.display(self.U)
        move = self.getPolicy(pacman,legal)

        # perform policy iteration and select policy based on location
        # self.policyIteration()
        # self.display(self.P)
        # move = self.P[pacman[0]][pacman[1]]
        # print moves

        return api.makeMove(move, legal)

    # return move with max utility from legal moves
    def getPolicy(self, location, legal):
        move = None
        val = -10000
        for i in legal:
            s = self.getCoordsFromDirection(location, i)
            if self.U[s[0]][s[1]] > val:
                move = i
                val = self.U[s[0]][s[1]]
        return move

	# perform policy iteration for size of width of map
    def policyIteration(self):
        count = 0
        while count < self.MAX_X:
            u = list(self.U)

            for x in range(self.MAX_X):
                for y in range(self.MAX_Y):
                    if (x,y) not in self.WALLS:
                        us = []
                        legal = self.getLegal([x,y])
                        for i in legal:
                            ts = self.ts([x,y],i)
                            us.append(sum([ u[a['x']][a['y']]*a['p'] for a in ts ]))
                        self.U[x][y] = self.R[x][y] + self.g * max(us)
                        self.P[x][y] = self.getPolicy([x,y],legal)
            count = count +1

    # display the utility grid
    def display(self, u):
        for i in u:
            print i

    # perform value iteration for size of width of the map
    def valueIteration(self):
        count = 0
        while count < self.MAX_X:
            u = list(self.U)

            for x in range(self.MAX_X):
                for y in range(self.MAX_Y):
                    if (x,y) not in self.WALLS:
                        us = []
                        for i in self.getLegal([x,y]):
                            ts = self.ts([x,y],i)
                            us.append(sum([ u[a['x']][a['y']]*a['p'] for a in ts ]))
                        self.U[x][y] = self.R[x][y] + self.g * max(us)

            count = count +1

    # return a list of dicts with the transition states
    # for a specific move with probability of move and its x, y
    def ts(self, location, direction):
        x = location[0]
        y = location[1]

        s = {'West': { 'x': x - 1, 'y': y},
            'East': {'x': x + 1, 'y': y },
            'South': {'x': x, 'y': y - 1 },
            'North': {'x': x, 'y': y + 1}}

        left,right = self.getAdjacent(direction)
        adj = [left, right]
        [adj.remove(v) for v in adj if (s[v]['x'],s[v]['y'] in self.WALLS)]

        move_info = [{
                    'dir' : direction,
                    'p': 1.0-(0.1*len(adj)),
                    'x': s[direction]['x'],
                    'y': s[direction]['y']}]

        for k in adj: move_info.append({
                    'dir' : k,
                    'p': 0.1,
                    'x': s[k]['x'],
                    'y': s[k]['y']})

        return move_info

    # translate a direction [North,East,South,West] into
    # a coordinate on the map based on given location
    def getCoordsFromDirection(self,pacman,direction):
            x = pacman[0]
            y = pacman[1]

            directions = [{'x': x - 1, 'y': y, 'direction': 'West'},
                            {'x': x + 1, 'y': y, 'direction': 'East'},
                            {'x': x, 'y': y - 1, 'direction': 'South'},
                            {'x': x, 'y': y + 1, 'direction': 'North'}]

            move = None
            for i in directions:
                if i['direction'] == direction:
                    move = i

            return [move['x'],move['y']]

    # return left and right moves from a given direction
    def getAdjacent(self,direction):
        moves = ['North','East','South','West']

        r_dir = moves.index(direction)+1
        if r_dir > len(moves)-1: r_dir = 0

        left = moves[moves.index(direction)-1]
        right = moves[r_dir]

        return left, right

    # return legal moves from a location on the grid
    # based on location of the walls
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

    # based on wall locations, identify the map limits X and Y
    def getMapLimits(self,walls):
        for i in walls:
            x = i[0]+1
            y = i[1]+1
            if x>self.MAX_X:
                self.MAX_X = x
            if y>self.MAX_Y:
                self.MAX_Y = y
        return walls

    # return a map of reward values for good locations and ghosts on map
    def getCellRewards(self,walls,food_location,ghosts, location):
        r = self.initMatrix(self.MAX_X,self.MAX_Y)

        for x,y in food_location:
            r[x][y] = 10
        for x,y in ghosts:
            # all cells surrounding a ghosts get a score of -10 * self.MAX_X
            r[int(x)][int(y)] = -50 * self.MAX_X
            r[int(x)+1][int(y)] = -30 * self.MAX_X
            r[int(x)-1][int(y)] = -30 * self.MAX_X
            r[int(x)][int(y)+1] = -30 * self.MAX_X
            r[int(x)][int(y)-1] = -30 * self.MAX_X
        for x,y in walls:
            r[x][y] = 0

        return r

    # initialize an empty 2D array
    def initMatrix(self, x_len, y_len):
        m = []
        for x in range(0,x_len):
            line = []
            for y in range(0,y_len):
                line.append(0)
            m.append(line)
        return m
