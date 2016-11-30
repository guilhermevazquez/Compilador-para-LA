/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package trabalho1;

import java.util.Stack;



/**
 *
 * @author Esquilo
 */
public class STRCTContext {
    String structName;
    int mode;
    TabelaDeSimbolos_STRCT tabelaDeEstruturas;
    Stack<TabelaDeSimbolos_STRCT> paiStack;
    TabelaDeSimbolos_VAR tabelaVARBase;
    
    STRCTContext(TabelaDeSimbolos_STRCT tabela, TabelaDeSimbolos_VAR tabelaBase)
    {
        tabelaDeEstruturas = tabela;
        tabelaVARBase = tabelaBase;
        mode = 0;
    }
    
    void setSTRCTContext(String name)
    {
        if(tabelaDeEstruturas.verificar(name) == null)
            tabelaDeEstruturas.inserir(name);
        
        structName = name;
        mode = 1;
    }
    
    void setSTRCTContext(int modo)
    {
        if(modo > 0)
            mode = 1;
        else
            mode = 0;
    }
    
    void enterSTRCTLevel(String nomeEstrutura)
    {
        EntradaTS_STRCT etds = tabelaDeEstruturas.verificar(nomeEstrutura);
        if(etds == null)
            return;
        else
        {
            paiStack.push(tabelaDeEstruturas);
            tabelaDeEstruturas = etds.estruturasAninhadas;
        }
    }
    
    void leaveSTRCTLevel()
    {
        tabelaDeEstruturas = paiStack.pop();
    }
    
    void insereVariavel(String nome, EntradaTS_TIPO tipo, int dimensao, int nPonteiros)
    {
        if(mode == 0)
        {
            tabelaVARBase.inserir(nome, tipo, dimensao, nPonteiros);
        }else
        {
            tabelaDeEstruturas.inserirVarEmSTRCT(structName, nome, tipo, dimensao, nPonteiros);
        }
    }
    
    EntradaTS_VAR verificaVariavel(String nome)
    {
        if(mode == 0)
        {
            return tabelaVARBase.verificar(nome);
        }else
        {
            return tabelaDeEstruturas.verificarVarEmSTRCT(structName, nome);
        }
    }
}
