class Allergies(object):

    def __init__(self, score):
        self.items = ['eggs', 'peanuts', 'shellfish', 'strawberries',
                      'tomatoes', 'chocolate', 'pollen', 'cats']
        self.allergies = [item for i, item in enumerate(self.items)
                          if score & (1 << i)]

    def is_allergic_to(self, item):
        return item in self.allergies

    @property
    def lst(self):
        return self.allergies
