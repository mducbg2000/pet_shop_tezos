
import smartpy as sp

class PetShop(sp.Contract):
    def __init__(self, creator):
        self.init(pets = {}, creator = creator)

    @sp.entry_point
    def addPet(self, params):
        sp.verify(self.data.creator == sp.sender, "Only shop owner can add new pet")
        sp.set_type(params.pet.petId, sp.TInt)
        self.data.pets[params.pet.petId] = params.pet

    @sp.entry_point
    def buy(self, params):
        pet = self.data.pets[params.petId]
        sp.verify(pet.owner == self.data.creator, "Pet already has an owner")
        sp.verify(sp.amount >= pet.price, "Not enough money")
        sp.send(pet.owner, sp.amount)
        pet.owner = sp.sender

@sp.add_test(name="PetShop")
def test():
    creator = sp.test_account("Creator")
    duke    = sp.test_account("Duke")
    zed     = sp.test_account("Zed")

    c1 = PetShop(creator.address)
    scenario = sp.test_scenario()
    scenario.h1("Pet shop")
    scenario += c1
    def newPet(petId, price):
        return sp.record(petId = petId, owner = creator.address, price = sp.mutez(price))
    c1.addPet(pet = newPet(1, 10)).run(sender = creator)
    c1.addPet(pet = newPet(2, 20)).run(sender = creator)
    c1.addPet(pet = newPet(3, 30)).run(sender = creator)
    c1.addPet(pet = newPet(4, 40)).run(sender = creator)
    c1.buy(petId = 4).run(sender = duke, amount = sp.mutez(40))
    scenario.h2("Bad executions")
    c1.addPet(pet = newPet(4, 50)).run(sender = duke, valid = False)
    c1.buy(petId = 2).run(sender = duke, amount = sp.mutez(10), valid = False)
    c1.buy(petId = 4).run(sender = zed, amount = sp.mutez(50), valid = False)

sp.add_compilation_target("petshop", PetShop(creator = sp.address("tz1ZDY3u3VbqPh2J4TskgLuB6GKkJg11ftyx")))



        