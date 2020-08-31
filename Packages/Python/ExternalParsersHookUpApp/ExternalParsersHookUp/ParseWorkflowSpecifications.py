from .RakuCommandFunctions import RakuCommand


def ToDataQueryWorkflowCode(command, parse=True, target='Python-pandas', globals=globals()):
    if target in ['pandas']:
        target = 'Python-' + target

    pres = RakuCommand(command=''.join(["say ToDataQueryWorkflowCode('", command, "', '", target, "')"]),
                       moduleName='DSL::English::DataQueryWorkflows')

    if len(pres.stderr) > 0:
        print(pres.stderr)

    if parse:
        exec(pres.stdout, globals)

    return pres.stdout
