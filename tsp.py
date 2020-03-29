import random

distances =[[0, 129, 206, 569, 107, 360, 284, 144, 115, 162, 200, 231, 288, 226, 436, 272, 174, 231, 297, 252, 118, 146, 258, 347, 121, 227, 200],
                [129,   0, 153, 696, 236, 395, 155, 139, 130, 291, 329, 360, 417, 123, 565, 401,  71, 176, 426, 381, 247, 225, 387, 476, 250, 356, 329],
                [206, 153,   0, 777, 315, 780, 312,  82,  93, 370, 406, 428, 496, 116, 644, 480, 827,  23, 505, 460, 293, 188, 466, 565, 329, 435, 408],
                [569, 696, 777,   0, 462, 398, 797, 713, 694, 407, 369, 388, 291, 795, 150, 314,  43, 800, 272, 317, 504, 609, 349, 222, 544, 356, 488],
                [107, 236, 315, 462,   0, 388, 408, 251, 222,  55,  93, 152, 181, 333, 329, 185, 281, 338, 190, 145, 137, 242, 151, 240,  82, 120,  93],
                [360, 395, 780, 398, 388,   0, 466, 479, 456, 194, 156, 266, 195, 435, 249, 107, 436, 542, 192, 197, 197, 492, 229, 199, 335, 131, 133],
                [284, 155, 312, 797, 408, 466,   0, 314, 302, 446, 484, 504, 567, 276, 640, 587, 228, 332, 568, 524, 414, 354, 524, 610, 408, 510, 435],
                [144, 139,  82, 713, 251, 479, 314,   0,  29, 306, 344, 364, 432, 112, 580, 416,  68, 105, 441, 396, 229, 124, 402, 491, 265, 371, 344],
                [115, 130 , 93, 694, 222, 456, 302,  29,   0, 277, 315, 335, 403, 111, 551, 387,  59, 116, 412, 367, 200,  95, 373, 462, 236, 342, 315],
                [162, 291, 370, 407,  55, 194, 446, 306, 277,   0,  37, 118, 126, 388, 274, 110, 336, 393, 135, 114, 192, 297, 118, 185, 137,  65,  81],
                [200, 329, 406, 369,  93, 156, 484, 344, 315,  37,   0, 153,  88, 426, 236,  72, 374, 431,  97,  82, 230, 335, 114, 147, 175,  27, 119],
                [231, 360, 428, 388, 152, 266, 504, 364, 335, 118, 153,   0, 111, 446, 325, 185, 394, 451, 116,  71, 135, 240,  45, 166, 234, 140, 199],
                [288, 417, 496, 291, 181, 195, 567, 432, 403, 126,  88, 111,   0, 514, 214,  87, 462, 519,   9,  40, 227, 332,  72,  59, 263,  75, 207],
                [226, 123, 116, 795, 333, 435, 276, 112, 111, 388, 426, 446, 514,   0, 682, 498,  52, 139, 523, 478, 311, 206, 484, 573, 347, 453, 426],
                [436, 565, 644, 150, 329, 249, 640, 580, 551, 274, 236, 325, 214, 682,   0, 164, 610, 667, 223, 254, 411, 546, 286, 251, 411, 209, 355],
                [272, 401, 480, 314, 185, 107, 587, 416, 387, 110,  72, 185,  87, 498, 164,   0, 446, 503,  87, 114, 301, 406, 146, 103, 247,  45, 191],
                [174,  71, 827,  43, 281, 436, 228,  68,  59, 336, 374, 394, 462,  52, 610, 446,   0, 105, 471, 426, 259, 254, 432, 521, 295, 401, 374],
                [231, 176,  23, 800, 338, 542, 332, 105, 116, 393, 431, 451, 519, 139, 667, 503, 105,   0, 528, 483, 316, 211, 489, 578, 352, 458, 431],
                [297, 426, 505, 272, 190, 192, 568, 441, 412, 135,  97, 116,   9, 523, 223,  87, 471, 528,   0,  45, 232, 337,  77,  50, 272,  84, 216],
                [252, 381, 460, 317, 145, 197, 524, 396, 367, 114,  82,  71,  40, 478, 254, 114, 426, 483,  45,   0, 187, 292,  32,  95, 227,  69, 195],
                [118, 247, 293, 504, 137, 197, 414, 229, 200, 192, 230, 135, 227, 311, 411, 301, 259, 316, 232, 187,   0, 105, 180, 282, 174, 256, 230],
                [146, 225, 188, 609, 242, 492, 354, 124,  95, 297, 335, 240, 332, 206, 546, 406, 254, 211, 337, 292, 105,   0, 285, 387, 287, 361, 335],
                [258, 387, 466, 349, 151, 229, 524, 402, 373, 118, 114,  45,  72, 484, 286, 146, 432, 489,  77,  32, 180, 285,   0, 127, 233, 101, 199],
                [347, 476, 565, 222, 240, 199, 610, 491, 462, 185, 147, 166,  59, 573, 251, 103, 521, 578,  50,  95, 282, 387, 127,   0, 322, 134, 266],
                [121, 250, 329, 544,  82, 335, 408, 265, 236, 137, 175, 234, 263, 347, 411, 247, 295, 352, 272, 227, 174, 287, 233, 322,   0, 202, 175],
                [227, 356, 435, 356, 120, 131, 510, 371, 342,  65,  27, 140,  75, 453, 209,  45, 401, 458,  84,  69, 256, 361, 101, 134, 202,   0, 146],
                [200, 329, 408, 488,  93, 133, 435, 344, 315,  81, 119, 199, 207, 426, 355, 191, 374, 431, 216, 195, 230, 335, 199, 266, 175, 146,   0]]

cities = {"0":"Bakersfield", "1":"Barstow", "2":"Carlsbad", "3":"Eureka", "4":"Fresno", "5":"Lake Tahoe", "6":"Las Vegas",
              "7":"Long Beach", "8":"Los Angeles", "9":"Merced", "10":"Modesto", "11":"Monterey", "12":"Oakland", "13":"Palm Springs",
              "14":"Redding", "15":"Sacramento", "16":"San Bernardino", "17":"San Diego", "18":"San Francisco", "19":"San Jose",
              "20":"San Luis Obispo", "21":"Santa Barbara", "22":"Santa Cruz", "23":"Santa Rosa", "24":"Sequoia Park", "25":"Stockon",
              "26":"Yosemite"}
def main():
    initialCircuit = [str(x) for x in range(27)]
    population = []
    # creating initial population of 1000 members
    getPermutations(initialCircuit, [], population)
    minpos = None
    # running program for 1000 generations
    for i in range(10000):
        fitnessOfCurrentPopulation = getFitness(population)
        currBestFitness = min(fitnessOfCurrentPopulation)
        minpos = fitnessOfCurrentPopulation.index(currBestFitness)
        averageFitness = sum(fitnessOfCurrentPopulation)//len(fitnessOfCurrentPopulation)
        print("Best Fitness in Generation " + str(i+1) + " = " + str(currBestFitness))
        print("Average Fitness in Generation " + str(i+1) + " = " + str(averageFitness))
        if i == 9999:
            printBestPathSoFar(population[minpos])
        newPopulation = []
        # getting 700 members from previous population into new population
        tournamentSelection(population, fitnessOfCurrentPopulation, newPopulation)
        # getting 290 members from recombination
        recombinationOfPopulation(newPopulation)
        # getting 10 members from mutation
        mutationOfPopulation(newPopulation)
        population = newPopulation[:]

def getPermutations(array, currentPermutation, permutations):
    if len(permutations) == 1000:
        return
    if not len(array) and len(currentPermutation):
        permutations.append(currentPermutation)
    else:
        for i in range(len(array)):
            newArray = array[:i] + array[i+1:]
            newPermutation = currentPermutation + [array[i]]
            getPermutations(newArray, newPermutation, permutations)

def getFitness(population):
    fitness = [0 for x in range(1000)]
    for i in range(len(population)):
        currCircuit = population[i]
        fitness[i] = calcFitness(currCircuit)
    return fitness

def calcFitness(circuit):
    currDist = 0
    for i in range(1,len(circuit)):
        currDist += distances[int(circuit[i-1])][int(circuit[i])]
    return currDist

def tournamentSelection(population, fitnessLevels, newPopulation):
    #choosing 800 random members of the population and then 700 most fittest members from the random list
    alreadyChosen = set()
    tempList = []
    while len(tempList) < 800:
        randomNumber = random.randint(0,999)
        if randomNumber not in alreadyChosen:
            tempList.append((population[randomNumber], fitnessLevels[randomNumber]))
            alreadyChosen.add(randomNumber)
    tempList.sort(key=lambda x: x[1])
    for i in range(700):
        newPopulation.append(tempList[i][0])

def recombinationOfPopulation(population):
    usedParents = set()
    childrenProduced = 0
    while childrenProduced < 290:
        p1 = random.randint(0,699)
        while p1 in usedParents:
            p1 = random.randint(0,699)
        usedParents.add(p1)
        p2 = random.randint(0,699)
        while p2 in usedParents:
            p2 = random.randint(0,699)
        usedParents.add(p2)
        children = getNewChildren(population[p1], population[p2])
        childrenProduced += 2
        population.append(children[0])
        population.append(children[1])

def getNewChildren(parent1, parent2):
    possibleValues = [str(x) for x in range(27)]
    parent1set = set(possibleValues)
    parent2set = set(possibleValues)
    usedLoci = set()
    loci1 = random.randint(0,26)
    usedLoci.add(loci1)
    loci2 = random.randint(0,26)
    while loci2 in usedLoci:
        loci2 = random.randint(0,26)
    child1 = [None for x in range(27)]
    child2 = [None for x in range(27)]
    for i in range(min(loci1,loci2), max(loci1, loci2)):
        child1[i] = parent2[i]
        child2[i] = parent1[i]
        parent1set.remove(parent2[i])
        parent2set.remove(parent1[i])
    for i in range(len(parent1)):
        if child1[i] == None and parent1[i] in parent1set:
            child1[i] = parent1[i]
            parent1set.remove(parent1[i])
        if child2[i] == None and parent2[i] in parent2set:
            child2[i] = parent2[i]
            parent2set.remove(parent2[i])
    for i in range(len(child1)):
        if child1[i] == None:
            child1[i] = parent1set.pop()
        if child2[i] == None:
            child2[i] = parent2set.pop()

    return [child1, child2]

def mutationOfPopulation(population):
    usedParents = set()
    childrenProduced = 0
    while childrenProduced < 10:
        parent = random.randint(0,989)
        while parent in usedParents:
            parent = random.randint(0,989)
        usedParents.add(parent)
        mutatedChild = mutate(population[parent])
        population.append(mutatedChild)
        childrenProduced += 1

def mutate(parent1):
    usedLoci = set()
    loci1 = random.randint(0, 26)
    usedLoci.add(loci1)
    loci2 = random.randint(0, 26)
    while loci2 in usedLoci:
        loci2 = random.randint(0, 26)
    parent1[loci1], parent1[loci2] = parent1[loci2], parent1[loci1]
    return parent1

def printBestPathSoFar(path):
    citiesList = [cities[x] for x in path]
    print (" -> ".join(citiesList))

#Las Vegas -> Barstow -> Palm Springs -> San Diego -> Carlsbad -> Long Beach -> Los Angeles -> Santa Barbara -> San Luis Obispo ->
# Merced -> Modesto -> Stockon -> Oakland -> Sacramento -> Redding -> Eureka -> San Bernardino -> Bakersfield -> Sequoia Park ->
# Fresno -> Yosemite -> Lake Tahoe -> Santa Rosa -> San Francisco -> San Jose -> Santa Cruz -> Monterey

#Las Vegas -> Barstow -> Palm Springs -> Long Beach -> Los Angeles -> Bakersfield -> Sequoia Park -> Fresno -> Yosemite ->
#Merced -> Modesto -> Stockon -> Sacramento -> Lake Tahoe -> Redding -> Eureka -> San Bernardino -> San Diego -> Carlsbad ->
#Santa Barbara -> San Luis Obispo -> Monterey -> Santa Cruz -> San Jose -> Oakland -> San Francisco -> Santa Rosa
# 2301
main()

