//
//  RelatorioServicoScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 31/07/23.
//

import SwiftUI

struct RelatorioServicoScreen: View
{
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ServicoEfetuadoViewModel()
    @State var textoFiltro: String = "Todos"
    @State var filtroPeriodo: [String: String] = ["Periodo": ""]
    @State private var isShowingSheet = false
    let pub = NotificationCenter.default.publisher(for: Notification.Name("Filtro"))
    
    var body: some View
    {
        VStack
        {
            List
            {
                Section(header: Text(textoFiltro).foregroundColor(.white), footer: Text("Total: " + String(viewModel.servicoEfetuadoLista.map{$0.custo}.reduce(0, +)).toCurrencyFormat()).foregroundColor(.white))
                {
                    ForEach(viewModel.servicoEfetuadoLista, id: \.self) { servico in
                        VStack
                        {
                            HStack
                            {
                                Text(String(servico.nome ?? ""))
                                Spacer()
                                Text(String(servico.quilometragem).toQuilometrosFormat())
                            }
                            HStack
                            {
                                Text(servico.data!, format: Date.FormatStyle().year().month().day())
                                Spacer()
                                Text(String(servico.custo).toCurrencyFormat())
                            }
                        }
                    }
                }
            }.scrollContentBackground(.hidden)
            
            Spacer()
            
        }.onReceive(pub) { msg in
            if let info = msg.userInfo, let infoPeriodo = info["Periodo"] as? String
            {
                ajustarHeader(info: infoPeriodo)
            }
        }
        .sheet(isPresented: $isShowingSheet)
                { SelecaoDataView(isShowingSheet: $isShowingSheet)}
        .background(Color("backGroundColor"))
        .navigationTitle("Serviço")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing)
            {
                Menu
                {
                    Button("Mês atual", action: { filtroPeriodo["Periodo"] = "Mês atual"; NotificationCenter.default.post(name: NSNotification.Name("Filtro"), object: nil, userInfo: filtroPeriodo)})
                    Button("Selecionar", action: { isShowingSheet = true; filtroPeriodo["Periodo"] = "Selecionar"; NotificationCenter.default.post(name: NSNotification.Name("Filtro"), object: nil, userInfo: filtroPeriodo)})
                    Button("Últimos 15 dias", action: { filtroPeriodo["Periodo"] = "Últimos 15 dias"; NotificationCenter.default.post(name: NSNotification.Name("Filtro"), object: nil, userInfo: filtroPeriodo)})
                    Button("Últimos 30 dias", action: { filtroPeriodo["Periodo"] = "Últimos 30 dias"; NotificationCenter.default.post(name: NSNotification.Name("Filtro"), object: nil, userInfo: filtroPeriodo)})
                    Button("Limpar seleção", action: { filtroPeriodo["Periodo"] = "Limpar"; NotificationCenter.default.post(name: NSNotification.Name("Filtro"), object: nil, userInfo: filtroPeriodo)})
                } label: { Label("", systemImage: "line.3.horizontal.decrease.circle").foregroundColor(.blue).imageScale(.large)}
            }
        }
    }
    
    func ajustarHeader(info: String)
    {
        textoFiltro = info
        viewModel.filter(tipo: textoFiltro)
    }
}
