from ranger.api.commands import Command
class quitallcd(Command):
    def execute(self):
        if self.arg(1):
            tmp_file = self.rest(1)
            cur_dir = self.fm.thisdir.path
            with open(tmp_file, "w") as f:
                f.write(cur_dir)
            self.fm.execute_console("quitall")