# sampleAgents.py
# parsons/07-oct-2017
#
# Version 1.1
#
# Some simple agents to work with the PacMan AI projects from:
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

# The agents here are extensions written by Simon Parsons, based on the code in
# pacmanAgents.py

from pacman import Directions
from game import Agent
import api
import random
import game
import util

# RandomAgent
#
# A very simple agent. Just makes a random pick every time that it is
# asked for an action.
class RandomAgent(Agent):

    def getAction(self, state):
        # Get the actions we can try, and remove "STOP" if that is one of them.
        legal = api.legalActions(state)
        if Directions.STOP in legal:
            legal.remove(Directions.STOP)
        # Random choice between the legal options.
        return api.makeMove(random.choice(legal), legal)

# RandomishAgent
#
# A tiny bit more sophisticated. Having picked a direction, keep going
# until that direction is no longer possible. Then make a random
# choice.
class RandomishAgent(Agent):

    # Constructor
    #
    # Create a variable to hold the last action
    def __init__(self):
         self.last = Directions.STOP
    
    def getAction(self, state):
        # Get the actions we can try, and remove "STOP" if that is one of them.
        legal = api.legalActions(state)
        if Directions.STOP in legal:
            legal.remove(Directions.STOP)
        # If we can repeat the last action, do it. Otherwise make a
        # random choice.
        if self.last in legal:
            return api.makeMove(self.last, legal)
        else:
            pick = random.choice(legal)
            # Since we changed action, record what we did
            self.last = pick
            return api.makeMove(pick, legal)

# SensingAgent
#
# Doesn't move, but reports sensory data available to Pacman
class SensingAgent(Agent):

    def getAction(self, state):

        # Demonstrates the information that Pacman can access about the state
        # of the game.

        # What are the current moves available
        legal = api.legalActions(state)
        print "Legal moves: ", legal

        # Where is Pacman?
        pacman = api.whereAmI(state)
        print "Pacman position: ", pacman

        # Where are the ghosts?
        print "Ghost positions:"
        theGhosts = api.ghosts(state)
        for i in range(len(theGhosts)):
            print theGhosts[i]

        # How far away are the ghosts?
        print "Distance to ghosts:"
        for i in range(len(theGhosts)):
            print util.manhattanDistance(pacman,theGhosts[i])

        # Where are the capsules?
        print "Capsule locations:"
        print api.capsules(state)
        
        # Where is the food?
        print "Food locations: "
        print api.food(state)

        # Where are the walls?
        print "Wall locations: "
        print api.walls(state)
        
        # getAction has to return a move. Here we pass "STOP" to the
        # API to ask Pacman to stay where they are.
        return api.makeMove(Directions.STOP, legal)

# MyGreedyAgent
#
# Doesn't move, but reports sensory data available to Pacman
class MyGreedyAgent(Agent):
        
    MAX_X = 0
    MAX_Y = 0

    VALUE_MAP = []
    def getLegal(self, x, y, walls):
        legal = []
        directions = [{'x': x - 1, 'y': y, 'direction': 'West'},
                    {'x': x + 1, 'y': y, 'direction': 'East'},
                    {'x': x, 'y': y - 1, 'direction': 'South'},
                    {'x': x, 'y': y + 1, 'direction': 'North'}]
        
        for i in directions:
            if (i['x'],i['y']) not in walls:
                legal.append(i['direction'])

        return legal

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

    def getMoveInfo(self, pacman, direction):

        moves = ['North','East','South','West']

        r_dir = moves.index(direction)+1
        if r_dir > len(moves)-1:
            r_dir = 0

        left = moves[moves.index(direction)-1]
        right = moves[r_dir]
        
        m1 = self.getCoordsFromDirection(pacman,direction)
        ml = self.getCoordsFromDirection(pacman,left)
        mr = self.getCoordsFromDirection(pacman,right)

        move_info = {
            'direction' :{
                'direction':direction,
                'outcome': m1,
                'probability': 0.8,
                'value': self.VALUE_MAP[m1[0]][m1[1]],
                },
            'left' :{
                'direction': left,
                'outcome': ml,
                'probability': 0.1,
                'value': self.VALUE_MAP[ml[0]][ml[1]]
            },
            'right' :{
                'direction': right,
                'outcome': mr,
                'probability': 0.1,
                'value': self.VALUE_MAP[mr[0]][mr[1]]
            }
        }
        return move_info

    def getMapLimits(self,walls):
        for i in walls:
            if i[0]>self.MAX_X:
                self.MAX_X = i[0] 
            if i[1]>self.MAX_Y:
                self.MAX_Y =i[1] 
        print str(self.MAX_X) +" ; "+str(self.MAX_Y)

    def getCellRewards(self,walls,food_location,ghosts):
        value_map = []
        for i in range(self.MAX_X+1):
            line = []
            for i in range(self.MAX_Y+1):
                line.append(0)
            value_map.append(line)
        
        for x,y in walls:
            value_map[x][y] = -100
        for x,y in food_location:
            value_map[x][y] = 10
        for x,y in ghosts:
            value_map[int(x)][int(y)] = -10

        for i in value_map:
            print i
        return value_map
        
    def getAction(self, state):
        legal = api.legalActions(state)
        walls = api.walls(state)
        pacman = api.whereAmI(state)
        corners = api.corners(state)
        capsules = api.capsules(state)
        food_location = api.food(state)
        food_location.extend(capsules)
        ghosts = api.ghosts(state)

        if Directions.STOP in legal:
            legal.remove(Directions.STOP)

        self.getMapLimits(walls)
        self.VALUE_MAP = self.getCellRewards(walls,food_location,ghosts)

        expected_utility = []
        expected_dir_util = {}
        for i in legal:
            new_l = self.getMoveInfo(pacman,i)
            expected_utility = new_l['direction']['probability']*new_l['direction']['value'] 
            if new_l['left']['direction'] in legal:
                expected_utility = expected_utility + new_l['left']['probability'] * new_l['left']['value']
            if new_l['right']['direction'] in legal:
                expected_utility = expected_utility + new_l['right']['probability'] * new_l['right']['value']
            expected_dir_util[new_l['direction']['direction']] = expected_utility
            print(expected_utility)
        print ("")
        print str(expected_dir_util)


        move = max(expected_dir_util, key=expected_dir_util.get)
        print(move)

        return api.makeMove(move, legal)

# SimpleMDPAgent
#
# Doesn't move, but reports sensory data available to Pacman
class SimpleMDPAgent(Agent):
        
    MAX_X = 0
    MAX_Y = 0
    WALLS = []

    g = 1
    R = []
    U = []

    def getAction(self, state):
        legal = api.legalActions(state)
        walls = api.walls(state)
        pacman = api.whereAmI(state)
        corners = api.corners(state)
        capsules = api.capsules(state)
        food_location = api.food(state)
        food_location.extend(capsules)
        ghosts = api.ghosts(state)

        if Directions.STOP in legal:
            legal.remove(Directions.STOP)

        self.getMapLimits(walls)
        self.R = self.getCellRewards(walls, food_location, ghosts)

        if self.U == []:
            self.U = self.initMatrix(self.MAX_X,self.MAX_Y)

        while True:
            u = list(self.U)


            print ("")
            print(u)
            print "Pre u^ U."
            for i in u:
                print i
            for i in self.U:
                print i
            


            for x in range(self.MAX_X):
                for y in range(self.MAX_Y):

                    if (x,y) not in self.WALLS:
                        us = []
                        for i in self.getLegal([x,y]):
                            ts = self.ts([x,y],i)
                            us.append(sum([ u[a['x']][a['y']]*a['p'] for a in ts ]))
                        self.U[x][y] = self.R[x][y] + self.g * max(us)

            print "AFTER u^ U."
            for i in u:
                print i
            for i in self.U:
                print i

            
            if u == self.U :
                print "DONE"
                break
        
        move = None
        val = 0
        for i in legal:
            s = self.getCoordsFromDirection(pacman, i)
            if self.U[s[0]][s[1]] > val:
                move = i
                val = self.U[s[0]][s[1]]
                
        

        return api.makeMove(move, legal)
 
    def ts(self, location, direction):
    
        x = location[0]
        y = location[1]

        s = {  
            'West': { 'x': x - 1, 'y': y},
            'East': {'x': x + 1, 'y': y },
            'South': {'x': x, 'y': y - 1 },
            'North': {'x': x, 'y': y + 1}
        }
        left,right = self.getAdjacent(direction)
        adj = [left, right]
        [adj.remove(v) for v in adj if (s[v]['x'],s[v]['y'] in self.WALLS)]

        move_info = [{
            'dir' : direction, 
            'p': 1.0-(0.1*len(adj)),
            'x': s[direction]['x'],
            'y': s[direction]['y']
            }]
    
        for k in adj: move_info.append({
                    'dir' : k, 
                    'p': 0.1,
                    'x': s[k]['x'],
                    'y': s[k]['y']
                })

        return move_info

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

    def getCellRewards(self,walls,food_location,ghosts):
        r = self.initMatrix(self.MAX_X,self.MAX_Y)

        for x,y in walls:
            r[x][y] = 0
        for x,y in food_location:
            r[x][y] = 10
        for x,y in ghosts:
            r[int(x)][int(y)] = -10
        return r
        
    def initMatrix(self, x_len, y_len):
        m = []
        for x in range(0,x_len):
            line = []
            for y in range(0,y_len):
                line.append(0)
            m.append(line)
        return m
