# Globals for the bearings
# Change the values as you see fit
NORTH = 0
EAST = 1
SOUTH = 2
WEST = 3


class Robot(object):
    def __init__(self, bearing=NORTH, x=0, y=0):
        self.coordinates = (x, y)
        self.bearing = bearing
        self.brs = [0, 1, 2, 3]  # NORTH, EAST, SOUTH, WEST

    def turn_left(self):
        self.bearing = self.brs[self.bearing - 1 if self.bearing > 0 else 3]

    def turn_right(self):
        self.bearing = self.brs[self.bearing + 1 if self.bearing < 3 else 0]

    def advance(self):
        self.new_co = list(self.coordinates)
        if self.bearing == 0:
            self.new_co[1] += 1
        if self.bearing == 1:
            self.new_co[0] += 1
        if self.bearing == 2:
            self.new_co[1] -= 1
        if self.bearing == 3:
            self.new_co[0] -= 1
        self.coordinates = tuple(self.new_co)

    def simulate(self, instructions):
        for instruction in instructions:
            if instruction == 'L':
                self.turn_left()
            if instruction == 'R':
                self.turn_right()
            if instruction == 'A':
                self.advance()
