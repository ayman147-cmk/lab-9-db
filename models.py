from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, Date
from sqlalchemy.orm import declarative_base, relationship, sessionmaker

class SchemaManager:
    def __init__(self, u="root", p="", h="localhost", d="universite"):
        self.link = f"mysql+pymysql://{u}:{p}@{h}/{d}"
        self.base = declarative_base()
        self.engine = self._build_engine()
        self.session = sessionmaker(bind=self.engine)

    def _build_engine(self):
        try:
            return create_engine(self.link)
        except Exception as error:
            print(f"Error: {error}")
            return None

core = SchemaManager()
Base = core.base

class Etudiant(Base):
    __tablename__ = "ETUDIANT"
    id = Column(Integer, primary_key=True)
    nom = Column(String(100), nullable=False)
    email = Column(String(150), nullable=False, unique=True)
    inscriptions = relationship("Inscription", back_populates="std")

class Professeur(Base):
    __tablename__ = "PROFESSEUR"
    id = Column(Integer, primary_key=True)
    nom = Column(String(100), nullable=False)
    specialite = Column(String(100))

class Cours(Base):
    __tablename__ = "COURS"
    id = Column(Integer, primary_key=True)
    titre = Column(String(100), nullable=False)
    credits = Column(Integer, default=3)

class Inscription(Base):
    __tablename__ = "INSCRIPTION"
    id = Column(Integer, primary_key=True)
    etudiant_id = Column(Integer, ForeignKey("ETUDIANT.id"))
    cours_id = Column(Integer, ForeignKey("COURS.id"))
    std = relationship("Etudiant", back_populates="inscriptions")

if __name__ == "__main__":
    try:
        Base.metadata.create_all(core.engine)
        print("Verification: Tables generated")
    except Exception as failure:
        print(f"Status: {failure}")