from langchain_community.document_loaders import PyPDFLoader
import pickle
import os
from tqdm import tqdm

class PdfReader:
    def __init__(self) -> None:
        pass

    def read_pdf(self, filepath, path='./data'):

        filename, _ = os.path.splitext(os.path.basename(filepath))
        path += filename + '/' + 'SCHOOL_INFO/'

        if not os.path.exists(path):
            os.makedirs(path)
        print(f'-- Load pdf file {filename} --')
        loader = PyPDFLoader(filepath)
        pages = loader.load()
        print('-- start --')
        for page_no in tqdm(range(len(pages))):
            doc = pages[page_no]
            doc.page_content = doc.page_content.replace(u"\xa0", u" ")
            if doc.page_content:
                with open(path+'page'+str(page_no)+'.pkl', 'wb') as f:
                    pickle.dump(doc, f)