{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "mkdocs-git-revision-date-localized-plugin";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timvink";
    repo = "mkdocs-git-revision-date-localized-plugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z0a/V8wyo15E7bTumLRM+0QxMGXlxVc1Sx9uXlDbg+8=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  nativeBuildInputs = [ python3.pkgs.setuptools-scm ];

  propagatedBuildInputs = with python3.pkgs; [
    babel
    gitpython
    mkdocs
    pytz
  ];

  nativeCheckInputs = [ python3.pkgs.pytestCheckHook ];

  disabledTestPaths = [ "tests/test_builds.py" ];

  pythonImportsCheck = [ "mkdocs_git_revision_date_localized_plugin" ];

  meta = with lib; {
    description = "MkDocs plugin that enables displaying the date of the last git modification of a page";
    homepage = "https://github.com/timvink/mkdocs-git-revision-date-localized-plugin";
    changelog = "https://github.com/timvink/mkdocs-git-revision-date-localized-plugin/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ totoroot ];
  };
}