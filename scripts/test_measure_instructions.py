import importlib.util
from pathlib import Path
import tempfile
import unittest

spec = importlib.util.spec_from_file_location('measure', Path(__file__).with_name('measure-instructions.py'))
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)


class MeasurementTests(unittest.TestCase):
    def test_unicode_and_duplicate_shared_body(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root/'shared.md').write_text('\u65e5\u672c\n', encoding='utf-8')
            for name in ('a.md','b.md'):
                (root/name).write_text('{{ include "shared.md" }}', encoding='utf-8')
            c = m.measure(root, dict(id='x',conditions='test',reads=[dict(path=p,reason='test') for p in ('a.md','b.md')]))
            self.assertEqual((c['total_chars'],c['unique_chars'],c['duplicate_chars']), (6,3,3))
            self.assertEqual((c['file_reads'],c['unique_files']), (4,3))

    def test_metadata_removed(self):
        self.assertEqual(m.body('a.toml.tmpl', 'model = "foo"\ndeveloper_instructions = """\nHello\n"""\n'), 'Hello\n')
        self.assertEqual(m.body('a.md.tmpl', '---\nmodel: foo\n---\nHello\n'), 'Hello\n')
        with self.assertRaises(ValueError):
            m.body('a.toml.tmpl','developer_instructions = "escaped"')

    def test_failures(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            case = dict(id='x', conditions='test', reads=[dict(path='a.md',reason='test')])
            for content,error in [('{{ include "a.md" }}',ValueError),('{{ include "missing.md" }}',FileNotFoundError),('{{ .unsupported }}',ValueError),('{{ include "../outside.md" }}',ValueError)]:
                (root/'a.md').write_text(content)
                with self.assertRaises(error):
                    m.measure(root, case)

    def test_changed_and_removed_cases_visible(self):
        c = dict(id='x',conditions='new',reads=[],files=[],total_chars=3,unique_chars=3,duplicate_chars=0,file_reads=1,unique_files=1)
        old = dict(c,conditions='old',total_chars=5)
        text = m.markdown(dict(cases=[c]),dict(cases=[old,dict(old,id='removed')]))
        self.assertIn('NEW/CHANGED',text)
        self.assertIn('REMOVED',text)
        self.assertIn('-2',text)


if __name__ == '__main__':
    unittest.main()
