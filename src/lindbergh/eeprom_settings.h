int eepromSettingsInit(FILE *eeprom);
int getRegion();
int getFreeplay();
int setRegion(FILE *eeprom, int region);
int setFreeplay(FILE *eeprom, int freeplay);
int fixCreditSection(FILE *eeprom);
int fixCoinAssignmentsHummer(FILE *eeprom);